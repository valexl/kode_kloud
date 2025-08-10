module Progresses
  class CompleteLesson
    attr_reader :lesson_id, :course_id, :user_id

    def initialize(lesson_id:, course_id:, user_id:)
      @lesson_id = lesson_id
      @course_id = course_id
      @user_id = user_id
    end

    def self.call(lesson_id:, course_id:, user_id:)
      new(lesson_id: lesson_id, course_id: course_id, user_id: user_id).call
    end

    def call
      ensure_course_and_lesson!

      Sequent.command_service.execute_commands(
        Progress::Commands::CompleteLesson.new(
          aggregate_id: user_lesson_progress.aggregate_id,
          user_id: user_id,
          lesson_id: lesson_id,
          course_id: course_id
        ),
        Progress::Commands::SetCourseProgress.new(
          aggregate_id: course_progress_aggregate_id_for,
          user_id: user_id,
          course_id: course_id,
          progress: calculate_progress
        )
      )

      OpenStruct.new(
        lesson_id: lesson_id,
        user_id: user_id,
        status: "completed"
      )
    end

    private

    def ensure_course_and_lesson!
      CourseRecord.find_by!(aggregate_id: course_id)
      LessonRecord.find_by!(aggregate_id: lesson_id, course_id: course_id)
    end

    def user_lesson_progress
      @user_lesson_progress ||= UserLessonProgressRecord.find_by!(user_id: user_id, course_id: course_id, lesson_id: lesson_id)
    end

    def calculate_progress
      total = LessonRecord.where(course_id: course_id).count
      completed = UserLessonProgressRecord
        .where(user_id:, course_id:, status: "completed")
        .where.not(lesson_id:)
        .count
      completed += 1
      ((completed.to_f / total) * 100).round
    end

    def course_progress_aggregate_id_for
      rec = UserCourseProgressRecord.find_by(user_id: user_id, course_id: course_id)
      return rec.aggregate_id if rec
      (user_id.split("-")[0..1] + course_id.split("-")[2..-1]).join("-")
    end
  end
end
