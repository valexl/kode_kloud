require "rails_helper"

RSpec.describe "User Stats API", type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:course_a) { SecureRandom.uuid }
  let(:course_b) { SecureRandom.uuid }
  let(:lesson_a1) { SecureRandom.uuid }
  let(:lesson_a2) { SecureRandom.uuid }
  let(:lesson_b1) { SecureRandom.uuid }

  before do
    UserCourseProgressRecord.create!(aggregate_id: SecureRandom.uuid, user_id: user_id, course_id: course_a, progress: 100)
    UserCourseProgressRecord.create!(aggregate_id: SecureRandom.uuid, user_id: user_id, course_id: course_b, progress: 40)

    UserLessonProgressRecord.create!(aggregate_id: SecureRandom.uuid, user_id: user_id, course_id: course_a, lesson_id: lesson_a1, status: "completed")
    UserLessonProgressRecord.create!(aggregate_id: SecureRandom.uuid, user_id: user_id, course_id: course_a, lesson_id: lesson_a2, status: "started")
    UserLessonProgressRecord.create!(aggregate_id: SecureRandom.uuid, user_id: user_id, course_id: course_b, lesson_id: lesson_b1, status: "started")
  end

  describe "GET /lsm/api/v1/users/:id/stats" do
    it "returns aggregated learning stats" do
      get "/lsm/api/v1/users/#{user_id}/stats"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)

      expect(body["user_id"]).to eq(user_id)
      expect(body["courses"]["total"]).to eq(2)
      expect(body["courses"]["completed"]).to eq(1)
      expect(body["courses"]["in_progress"]).to eq(1)
      expect(body["courses"]["average_progress"]).to eq(70)
      expect(body["lessons"]["total"]).to eq(3)
      expect(body["lessons"]["completed"]).to eq(1)
      expect(body["lessons"]["in_progress"]).to eq(2)
    end

    it "returns zeros for a user without any progress" do
      other_user = SecureRandom.uuid
      get "/lsm/api/v1/users/#{other_user}/stats"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)

      expect(body["user_id"]).to eq(other_user)
      expect(body["courses"]["total"]).to eq(0)
      expect(body["courses"]["completed"]).to eq(0)
      expect(body["courses"]["in_progress"]).to eq(0)
      expect(body["courses"]["average_progress"]).to eq(0)
      expect(body["lessons"]["total"]).to eq(0)
      expect(body["lessons"]["completed"]).to eq(0)
      expect(body["lessons"]["in_progress"]).to eq(0)
    end
  end
end
