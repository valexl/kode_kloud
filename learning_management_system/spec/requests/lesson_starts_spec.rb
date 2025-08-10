require "rails_helper"

RSpec.describe "Start Lesson API", type: :request do
  let(:user_id)   { SecureRandom.uuid }
  let(:course_id) { SecureRandom.uuid }
  let(:lesson_id)  { SecureRandom.uuid }

  before do
    create_course!(aggregate_id: course_id, title: "Math", description: "Desc")
    create_lesson!(aggregate_id: lesson_id, title: "Lesson 1", description: "Intro", course_id: course_id)
  end

  describe "POST /lsm/api/v1/courses/:course_id/lessons/:id/start" do
    context "when starting a lesson for the first time" do
      it "returns 202 with the contract and creates lesson progress with status started" do
        post "/lsm/api/v1/courses/#{course_id}/lessons/#{lesson_id}/start", params: { user_id: user_id }, as: :json

        expect(response).to have_http_status(:accepted)
        body = JSON.parse(response.body)
        expect(body).to eq(
          "lesson_id" => lesson_id,
          "user_id" => user_id,
          "status" => "started"
        )

        ulp = UserLessonProgressRecord.find_by(user_id: user_id, lesson_id: lesson_id)
        expect(ulp).to be_present
        expect(ulp.status).to eq("started")
        
        ucp = UserCourseProgressRecord.find_by(user_id: user_id, course_id: course_id)
        expect(ucp).to be_present
        expect(ucp.progress).to eq(0)
      end
    end

    context "when starting the same lesson again (idempotent)" do
      it "returns 202 and keeps status started without affecting course progress" do
        post "/lsm/api/v1/courses/#{course_id}/lessons/#{lesson_id}/start", params: { user_id: user_id }, as: :json
        expect(response).to have_http_status(:accepted)

        post "/lsm/api/v1/courses/#{course_id}/lessons/#{lesson_id}/start", params: { user_id: user_id }, as: :json
        expect(response).to have_http_status(:accepted)

        ulp = UserLessonProgressRecord.find_by(user_id: user_id, lesson_id: lesson_id)
        expect(ulp).to be_present
        expect(ulp.status).to eq("started")

        ucp = UserCourseProgressRecord.find_by(user_id: user_id, course_id: course_id)
        expect(ucp).to be_present
        expect(ucp.progress).to eq(0)
      end
    end

    context "when user_id is missing" do
      it "returns 400 with error" do
        post "/lsm/api/v1/courses/#{course_id}/lessons/#{lesson_id}/start", as: :json
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when lesson_id is missing" do
      it "returns 404 with error" do
        post "/lsm/api/v1/courses/#{course_id}/lessons/non-existent-id/start", params: { user_id: user_id }, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when course_id is missing" do
      it "returns 404 with error" do
        post "/lsm/api/v1/courses/non-existent-id/lessons/#{lesson_id}/start", params: { user_id: user_id }, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
