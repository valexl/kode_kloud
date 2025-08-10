require "rails_helper"

RSpec.describe "Crs LMS Events", type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:course_id) { SecureRandom.uuid }

  describe "POST /crs/api/v1/lms-events" do
    context "when course_added event" do
      it "creates a course" do
        body = {
          type: "course_added",
          data: { course_id: course_id, title: "Math", description: "Basics" }
        }
        post "/crs/api/v1/lms-events", params: body, as: :json
        expect(response).to have_http_status(:accepted)
        course_record = CourseRecord.find_by(aggregate_id: course_id)
        expect(course_record.title).to eq("Math")
        expect(course_record.description).to eq("Basics")
      end
    end

    context "when course_deleted event" do
      it "removes a course" do
        create_course!(aggregate_id: course_id, title: "X", description: "Y")
        body = {
          type: "course_deleted",
          data: { course_id: course_id }
        }
        expect {
          post "/crs/api/v1/lms-events", params: body, as: :json
        }.to change { CourseRecord.count }.by(-1)
        expect(response).to have_http_status(:accepted)
        expect(CourseRecord.exists?(course_id)).to eq(false)
      end
    end

    context "when user_started_course event" do
      it "stores started progress" do
        create_course!(aggregate_id: course_id, title: "X", description: "Y")
        body = {
          type: "user_started_course",
          data: { user_id: user_id, course_id: course_id }
        }
        post "/crs/api/v1/lms-events", params: body, as: :json
        expect(response).to have_http_status(:accepted)
        progress_record = UserCourseProgressRecord.find_by(
          user_id: user_id,
          course_id: course_id
        )
        expect(progress_record.status).to eq("started")
      end
    end

    context "when user_finished_course event" do
      it "stores completed progress" do
        create_course!(aggregate_id: course_id, title: "X", description: "Y")
        start_course_for_user!(user_id:, course_id:)
        body = {
          type: "user_finished_course",
          data: { user_id: user_id, course_id: course_id }
        }
        post "/crs/api/v1/lms-events", params: body, as: :json
        expect(response).to have_http_status(:accepted)
        progress_record = UserCourseProgressRecord.find_by(
          user_id: user_id,
          course_id: course_id
        )
        expect(progress_record.status).to eq("completed")
      end
    end
  end
end
