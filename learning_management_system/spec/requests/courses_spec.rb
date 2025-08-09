require "rails_helper"

RSpec.describe "Courses API", type: :request do
  let(:uuid) { SecureRandom.uuid }

  let(:initial_title) { "Math 101" }
  let(:initial_description) { "Basic math course" }

  before do
    allow(Sequent).to receive(:new_uuid).and_return(uuid)
  end

  describe "POST /lsm/api/v1/courses" do
    it "creates a course and returns 201 with JSON" do
      payload = { course: { title: initial_title, description: initial_description } }

      post "/lsm/api/v1/courses", params: payload, as: :json

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["id"]).to match(/\A[0-9a-f\-]{36}\z/i)
      expect(body["title"]).to eq(initial_title)
      expect(body["description"]).to eq(initial_description)
    end

    it "persists aggregate state" do
      payload = { course: { title: initial_title, description: initial_description } }

      post "/lsm/api/v1/courses", params: payload, as: :json

      aggregate = Sequent.aggregate_repository.load_aggregate(uuid, Course::Course)
      expect(aggregate.instance_variable_get(:@title)).to eq(initial_title)
      expect(aggregate.instance_variable_get(:@description)).to eq(initial_description)
    end

    it "creates a CourseRecord via projector" do
      payload = { course: { title: initial_title, description: initial_description } }

      post "/lsm/api/v1/courses", params: payload, as: :json

      course_record = CourseRecord.find_by(aggregate_id: uuid)
      expect(course_record).to be_present
      expect(course_record.title).to eq(initial_title)
      expect(course_record.description).to eq(initial_description)
    end

    it "returns 422 on invalid input" do
      payload = { course: { title: "", description: "" } }

      post "/lsm/api/v1/courses", params: payload, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end
  end

  describe "PUT /lsm/api/v1/courses/:id" do
    let(:course_id) do
      create_course!(title: initial_title, description: initial_description)[:aggregate_id]
    end

    let(:updated_title) { "Advanced Math" }
    let(:updated_description) { "Math for pros" }

    it "updates a course and returns 200 with JSON" do
      update_payload = { course: { title: updated_title, description: updated_description } }

      put "/lsm/api/v1/courses/#{course_id}", params: update_payload, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["id"]).to eq(course_id)
      expect(body["title"]).to eq(updated_title)
      expect(body["description"]).to eq(updated_description)
    end

    it "updates aggregate state" do
      update_payload = { course: { title: updated_title, description: updated_description } }

      put "/lsm/api/v1/courses/#{course_id}", params: update_payload, as: :json

      aggregate = Sequent.aggregate_repository.load_aggregate(course_id, Course::Course)
      expect(aggregate.instance_variable_get(:@title)).to eq(updated_title)
      expect(aggregate.instance_variable_get(:@description)).to eq(updated_description)
    end

    it "updates the CourseRecord via projector" do
      update_payload = { course: { title: updated_title, description: updated_description } }

      put "/lsm/api/v1/courses/#{course_id}", params: update_payload, as: :json

      course_record = CourseRecord.find_by(aggregate_id: uuid)
      expect(course_record).to be_present
      expect(course_record.title).to eq(updated_title)
      expect(course_record.description).to eq(updated_description)
    end

    it "returns 422 on invalid input" do
      update_payload = { course: { title: "", description: "" } }

      put "/lsm/api/v1/courses/#{course_id}", params: update_payload, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end
  end

  describe "DELETE /lsm/api/v1/courses/:id" do
    let(:course_id) do
      create_course!(title: initial_title, description: initial_description)[:aggregate_id]
    end

    it "deletes a course and returns 204" do
      delete "/lsm/api/v1/courses/#{course_id}"
      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
      
      expect(CourseRecord.where(aggregate_id: course_id).empty?).to eq(true)
    end

    it "marks aggregate as deleted" do
      delete "/lsm/api/v1/courses/#{course_id}"
      aggregate = Sequent.aggregate_repository.load_aggregate(course_id, Course::Course)
      expect(aggregate).not_to be_nil
      expect(aggregate.deleted?).to be true
    end
  end
end
