require "rails_helper"

RSpec.describe Progresses::CompleteLesson do
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

    before do
      Progresses::StartLesson.call(
        lesson_id: lesson.aggregate_id,
        course_id: course.aggregate_id,
        user_id: user_id
      )
    end

    it "publishes user_finished_course with correct payload" do
      stub = stub_request(:post, url)
        .with(body: { type: "user_finished_course", data: { user_id: user_id, course_id: course.aggregate_id } }.to_json)
        .to_return(status: 202, body: "", headers: {})

      result = call

      expect(result.lesson_id).to eq(lesson.aggregate_id)
      expect(result.user_id).to eq(user_id)
      expect(result.status).to eq("completed")
      expect(stub).to have_been_requested
    end

    it "updates CourseProgress aggregate to 100 percent" do
      call

      expected_course_aggregate_id = (user_id.split("-")[0..1] + course.aggregate_id.split("-")[2..-1]).join("-")
      course_progress = Sequent.aggregate_repository.load_aggregate(expected_course_aggregate_id, Progress::CourseProgress)

      expect(course_progress.user_id).to eq(user_id)
      expect(course_progress.course_id).to eq(course.aggregate_id)
      expect(course_progress.progress).to eq(100)
    end

    it "marks LessonProgress aggregate as completed" do
      call

      expected_lesson_aggregate_id = (course.aggregate_id.split("-")[0..1] + lesson.aggregate_id.split("-")[2..-1]).join("-")
      lesson_progress = Sequent.aggregate_repository.load_aggregate(expected_lesson_aggregate_id, Progress::LessonProgress)

      expect(lesson_progress.user_id).to eq(user_id)
      expect(lesson_progress.course_id).to eq(course.aggregate_id)
      expect(lesson_progress.lesson_id).to eq(lesson.aggregate_id)
      expect(lesson_progress.status).to eq("completed")
    end

    it "updates UserCourseProgressRecord to 100 percent" do
      call

      user_course_progress_record = UserCourseProgressRecord.find_by(user_id: user_id, course_id: course.aggregate_id)
      expect(user_course_progress_record).to be_present
      expect(user_course_progress_record.progress).to eq(100)
    end

    it "updates UserLessonProgressRecord to completed" do
      call

      user_lesson_progress_record = UserLessonProgressRecord.find_by(user_id: user_id, course_id: course.aggregate_id, lesson_id: lesson.aggregate_id)
      expect(user_lesson_progress_record).to be_present
      expect(user_lesson_progress_record.status).to eq("completed")
    end
  end
end
