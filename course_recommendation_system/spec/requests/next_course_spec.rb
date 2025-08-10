require "rails_helper"

RSpec.describe "GET /crs/api/v1/users/:id/next-course", type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:course_1_id) { create_course!(title: "Course 1", description: "Desc 1") }
  let(:course_2_id) { create_course!(title: "Course 2", description: "Desc 2") }

  subject(:request_next_course) { get "/crs/api/v1/users/#{user_id}/next-course" }

  context "when user has not started or completed some courses" do
    let!(:course_1_id) { create_course!(title: "Course 1", description: "Desc 1") }
    let!(:course_2_id) { create_course!(title: "Course 2", description: "Desc 2") }

    before { start_course_for_user!(user_id:, course_id: course_1_id) }

    it "returns one of the available courses" do
      request_next_course
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect([course_1_id, course_2_id]).to include(body["course_id"])
      expect(body["course_id"]).not_to eq(course_1_id)
    end
  end

  context "when user has completed all courses" do
    before do
      start_course_for_user!(user_id:, course_id: course_1_id)
      complete_course_for_user!(user_id:, course_id: course_1_id)
    end

    it "returns 404" do
      request_next_course
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq("error" => "no_course_available")
    end
  end

  context "when there are no courses at all" do
    it "returns 404" do
      request_next_course
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq("error" => "no_course_available")
    end
  end
end
