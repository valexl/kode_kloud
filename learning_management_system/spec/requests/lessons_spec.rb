require "rails_helper"

RSpec.describe "Lessons API", type: :request do
  let(:lesson_id)  { SecureRandom.uuid }
  let(:course_id)  { SecureRandom.uuid }

  let(:initial_title)       { "Lesson 1" }
  let(:initial_description) { "Intro lesson" }

  before do
    allow(Sequent).to receive(:new_uuid).and_return(lesson_id)

    create_course!(aggregate_id: course_id, title: "Math 101", description: "Basic")
  end

  describe "POST /lsm/api/v1/lessons" do
    it "creates a lesson and returns 201 with JSON" do
      payload = { lesson: { title: initial_title, description: initial_description, course_id: course_id } }

      post "/lsm/api/v1/lessons", params: payload, as: :json

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["id"]).to eq(lesson_id)
      expect(body["title"]).to eq(initial_title)
      expect(body["description"]).to eq(initial_description)
      expect(body["course_id"]).to eq(course_id)
    end

    it "persists aggregate state" do
      payload = { lesson: { title: initial_title, description: initial_description, course_id: course_id } }

      post "/lsm/api/v1/lessons", params: payload, as: :json

      aggregate = Sequent.aggregate_repository.load_aggregate(lesson_id, Lesson::Lesson)
      expect(aggregate.title).to eq(initial_title)
      expect(aggregate.description).to eq(initial_description)
      expect(aggregate.course_id).to eq(course_id)
    end

    it "creates a LessonRecord via projector" do
      payload = { lesson: { title: initial_title, description: initial_description, course_id: course_id } }

      post "/lsm/api/v1/lessons", params: payload, as: :json

      lesson_record = LessonRecord.find_by(aggregate_id: lesson_id)
      expect(lesson_record).to be_present
      expect(lesson_record.title).to eq(initial_title)
      expect(lesson_record.description).to eq(initial_description)
      expect(lesson_record.course_id).to eq(course_id)
    end

    it "returns 422 on invalid input" do
      payload = { lesson: { title: "", description: "", course_id: "" } }

      post "/lsm/api/v1/lessons", params: payload, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end
  end

  describe "PUT /lsm/api/v1/lessons/:id" do
    let(:updated_title)       { "Updated Lesson" }
    let(:updated_description) { "Advanced part" }
    let(:existing_lesson_id) do
      create_lesson!(
        aggregate_id: lesson_id,
        course_id: course_id,
        title: initial_title,
        description: initial_description
      )[:aggregate_id]
    end

    it "updates a lesson and returns 200 with JSON" do
      update_payload = { lesson: { course_id: course_id, title: updated_title, description: updated_description } }

      put "/lsm/api/v1/lessons/#{existing_lesson_id}", params: update_payload, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["id"]).to eq(existing_lesson_id)
      expect(body["title"]).to eq(updated_title)
      expect(body["description"]).to eq(updated_description)
      expect(body["course_id"]).to eq(course_id)
    end

    it "updates aggregate state" do
      update_payload = { lesson: { course_id: course_id, title: updated_title, description: updated_description } }

      put "/lsm/api/v1/lessons/#{existing_lesson_id}", params: update_payload, as: :json

      aggregate = Sequent.aggregate_repository.load_aggregate(existing_lesson_id, Lesson::Lesson)
      expect(aggregate.title).to eq(updated_title)
      expect(aggregate.description).to eq(updated_description)
    end

    it "updates the LessonRecord via projector" do
      update_payload = { lesson: { course_id: course_id, title: updated_title, description: updated_description } }

      put "/lsm/api/v1/lessons/#{existing_lesson_id}", params: update_payload, as: :json

      rec = LessonRecord.find_by(aggregate_id: existing_lesson_id)
      expect(rec).to be_present
      expect(rec.title).to eq(updated_title)
      expect(rec.description).to eq(updated_description)
      expect(rec.course_id).to eq(course_id)
    end

    it "returns 422 on invalid input" do
      update_payload = { lesson: { course_id: course_id, title: "", description: "" } }

      put "/lsm/api/v1/lessons/#{existing_lesson_id}", params: update_payload, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end
  end

  describe "DELETE /lsm/api/v1/lessons/:id" do
    let(:existing_lesson_id) do
      create_lesson!(
        aggregate_id: lesson_id,
        course_id: course_id,
        title: initial_title,
        description: initial_description
      )[:aggregate_id]
    end

    it "deletes a lesson and returns 204" do
      delete "/lsm/api/v1/lessons/#{existing_lesson_id}"

      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
      expect(LessonRecord.where(aggregate_id: existing_lesson_id).empty?).to eq(true)
    end

    it "marks aggregate as deleted" do
      delete "/lsm/api/v1/lessons/#{existing_lesson_id}"

      aggregate = Sequent.aggregate_repository.load_aggregate(existing_lesson_id, Lesson::Lesson)
      expect(aggregate).not_to be_nil
      expect(aggregate.deleted?).to be true
    end
  end

  describe "GET /lsm/api/v1/lessons" do
    let(:lesson_id1) { SecureRandom.uuid }
    let(:lesson_id2) { SecureRandom.uuid }

    let!(:l1) { create_lesson!(aggregate_id: lesson_id1, course_id: course_id, title: "L1", description: "A") }
    let!(:l2) { create_lesson!(aggregate_id: lesson_id2, course_id: course_id, title: "L2", description: "B") }

    it "returns list of lessons" do
      get "/lsm/api/v1/lessons", as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)

      expect(body).to eq([
        { "id" => l1[:aggregate_id], "title" => "L1", "description" => "A", "course_id" => course_id },
        { "id" => l2[:aggregate_id], "title" => "L2", "description" => "B", "course_id" => course_id }
      ])
    end
  end

  describe "GET /lsm/api/v1/lessons/:id" do
    let(:existing_lesson_id) { SecureRandom.uuid }
    let!(:l1) do
      create_lesson!(
        aggregate_id: existing_lesson_id,
        course_id: course_id,
        title: "Lesson 1",
        description: "Intro"
      )
    end

    it "returns the lesson" do
      get "/lsm/api/v1/lessons/#{existing_lesson_id}", as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to eq(
        "id" => existing_lesson_id,
        "title" => "Lesson 1",
        "description" => "Intro",
        "course_id" => course_id
      )
    end

    it "returns 404 if lesson does not exist" do
      get "/lsm/api/v1/lessons/#{SecureRandom.uuid}", as: :json

      expect(response).to have_http_status(:not_found)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end
  end
end
