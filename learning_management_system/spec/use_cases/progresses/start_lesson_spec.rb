require "rails_helper"

RSpec.describe Progresses::StartLesson do
  let(:url) { ENV.fetch("INTEGRATION_EVENTS_URL") }
  let(:user_id) { SecureRandom.uuid }
  let(:course) { create_course!(title: "Math", description: "Basics") }
  let(:lesson) { create_lesson!(title: "L1", description: "D1", course_id: course.aggregate_id) }

  describe ".call" do
    subject(:call) do
      described_class.call(
        lesson_id: lesson.aggregate_id,
        course_id: course.aggregate_id,
        user_id: user_id
      )
    end

    it "publishes user_started_course with correct payload" do
      stub = stub_request(:post, url)
        .with(body: { type: "user_started_course", data: { user_id: user_id, course_id: course.aggregate_id } }.to_json)
        .to_return(status: 202, body: "", headers: {})

      call

      expect(stub).to have_been_requested
    end

    it "creates CourseProgress aggregate" do
      call

      expected_course_agg_id = (user_id.split("-")[0..1] + course.aggregate_id.split("-")[2..-1]).join("-")
      course_progress = Sequent.aggregate_repository.load_aggregate(expected_course_agg_id, Progress::CourseProgress)

      expect(course_progress.user_id).to eq(user_id)
      expect(course_progress.course_id).to eq(course.aggregate_id)
      expect(course_progress.progress).to eq(0)
    end

    it "creates LessonProgress aggregate" do
      call

      expected_lesson_agg_id = (course.aggregate_id.split("-")[0..1] + lesson.aggregate_id.split("-")[2..-1]).join("-")
      lesson_progress = Sequent.aggregate_repository.load_aggregate(expected_lesson_agg_id, Progress::LessonProgress)

      expect(lesson_progress.user_id).to eq(user_id)
      expect(lesson_progress.course_id).to eq(course.aggregate_id)
      expect(lesson_progress.lesson_id).to eq(lesson.aggregate_id)
      expect(lesson_progress.status).to eq("started")
    end

    it "creates UserCourseProgressRecord" do
      call

      user_course_progress_record = UserCourseProgressRecord.find_by(user_id: user_id, course_id: course.aggregate_id)
      expect(user_course_progress_record).to be_present
      expect(user_course_progress_record.progress).to eq(0)
    end

    it "creates UserLessonProgressRecord" do
      call

      user_lesson_progress_record = UserLessonProgressRecord.find_by(user_id: user_id, course_id: course.aggregate_id, lesson_id: lesson.aggregate_id)
      expect(user_lesson_progress_record).to be_present
      expect(user_lesson_progress_record.status).to eq("started")
    end
  end
end
