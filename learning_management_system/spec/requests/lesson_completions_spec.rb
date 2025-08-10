require "rails_helper"

RSpec.describe "Complete Lesson API", type: :request do
  let(:user_id)   { SecureRandom.uuid }
  let(:course_id) { SecureRandom.uuid }
  let(:lesson_1)  { SecureRandom.uuid }
  let(:lesson_2)  { SecureRandom.uuid }

  before do
    create_course!(aggregate_id: course_id, title: "Math", description: "Desc")
    create_lesson!(aggregate_id: lesson_1, title: "Lesson 1", description: "Intro", course_id: course_id)
  end

  describe "POST /lsm/api/v1/courses/:course_id/lessons/:id/complete" do
    context "when first lesson in the course is completed" do
      before do
        create_lesson!(aggregate_id: lesson_2, title: "Lesson 2", description: "Deep dive", course_id: course_id)
        Progresses::StartLesson.call(lesson_id: lesson_1, course_id: course_id, user_id: user_id)
      end

      it "returns 202 with the contract and creates both progress records at 50%" do
        post "/lsm/api/v1/courses/#{course_id}/lessons/#{lesson_1}/complete", params: { user_id: user_id }, as: :json
        expect(response).to have_http_status(:accepted)

        body = JSON.parse(response.body)
        expect(body).to eq(
          "lesson_id" => lesson_1,
          "user_id" => user_id,
          "status" => "completed"
        )

        user_lesson_progress = UserLessonProgressRecord.find_by(user_id: user_id, lesson_id: lesson_1)
        expect(user_lesson_progress.status).to eq("completed")

        user_course_progress = UserCourseProgressRecord.find_by(user_id: user_id, course_id: course_id)
        expect(user_course_progress.progress).to eq(50)
      end
    end

    context "when all lessons in the course became completed" do
      before do
        create_lesson!(aggregate_id: lesson_2, title: "Lesson 2", description: "Deep dive", course_id: course_id)
        Progresses::StartLesson.call(lesson_id: lesson_1, course_id: course_id, user_id: user_id)
        Progresses::CompleteLesson.call(lesson_id: lesson_1, course_id: course_id, user_id: user_id)
        Progresses::StartLesson.call(lesson_id: lesson_2, course_id: course_id, user_id: user_id)
      end

      it "returns 202 and course progress becomes 100%" do
        post "/lsm/api/v1/courses/#{course_id}/lessons/#{lesson_2}/complete", params: { user_id: user_id }, as: :json
        expect(response).to have_http_status(:accepted)

        user_course_progress = UserCourseProgressRecord.find_by(user_id: user_id, course_id: course_id)
        expect(user_course_progress.progress).to eq(100)
      end
    end

    context "when completing the same lesson again (idempotent)" do
      before do
        create_lesson!(aggregate_id: lesson_2, title: "Lesson 2", description: "Deep dive", course_id: course_id)
        Progresses::StartLesson.call(lesson_id: lesson_1, course_id: course_id, user_id: user_id)
        Progresses::CompleteLesson.call(lesson_id: lesson_1, course_id: course_id, user_id: user_id)
      end

      it "returns 202 and keeps status completed without changing course progress" do
        post "/lsm/api/v1/courses/#{course_id}/lessons/#{lesson_1}/complete", params: { user_id: user_id }, as: :json
        expect(response).to have_http_status(:accepted)
        user_course_progress = UserCourseProgressRecord.find_by(user_id: user_id, course_id: course_id)
        expect(user_course_progress.progress).to eq(50)
      end
    end

    context "when lesson was not started" do
      it "returns 404 with error" do
        post "/lsm/api/v1/courses/#{course_id}/lessons/#{lesson_1}/complete", params: { user_id: user_id }, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
