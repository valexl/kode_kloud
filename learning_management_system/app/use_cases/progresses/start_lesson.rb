module Progresses
  class StartLesson
    attr_reader :lesson_id, :course_id, :user_id

    def initialize(lesson_id:, course_id:, user_id:)
      @lesson_id = lesson_id
      @course_id = course_id
      @user_id = user_id
    end

    def self.call(lesson_id:, course_id:, user_id:)
      new(lesson_id:, course_id:, user_id:).call
    end

    def call
      ensure_course_and_lesson!
      Sequent.command_service.execute_commands(*commands)
      result
    end

    private

    def ensure_course_and_lesson!
      CourseRecord.find_by!(aggregate_id: course_id)
      LessonRecord.find_by!(aggregate_id: lesson_id, course_id: course_id)
    end

    def commands
      [
        Progress::Commands::StartCourse.new(
          aggregate_id: course_progress_aggregate_id,
          user_id: user_id,
          course_id: course_id
        ),
        Progress::Commands::StartLesson.new(
          aggregate_id: lesson_progress_aggregate_id,
          user_id: user_id,
          lesson_id: lesson_id,
          course_id: course_id
        )
      ]
    end

    def result
      OpenStruct.new(
        lesson_id: lesson_id,
        user_id: user_id,
        status: "started"
      )
    end

    def lesson_progress_aggregate_id
      (course_id.split("-")[0..1] + lesson_id.split("-")[2..-1]).join("-")
    end

    def course_progress_aggregate_id
      (user_id.split("-")[0..1] + course_id.split("-")[2..-1]).join("-")
    end
  end
end
