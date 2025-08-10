module Stats
  class UserStats
    attr_reader :user_id

    def initialize(user_id:)
      @user_id = user_id
    end

    def self.call(user_id:)
      new(user_id:).call
    end

    def call
      # TODO: the logic can be moved into repository in the future
      courses_scope = UserCourseProgressRecord.where(user_id: user_id)
      lessons_scope = UserLessonProgressRecord.where(user_id: user_id)

      courses_total = courses_scope.select(:course_id).distinct.count
      courses_completed = courses_scope.where(progress: 100).count
      courses_in_progress = [courses_total - courses_completed, 0].max
      average_progress = courses_scope.average(:progress)&.to_i || 0

      lessons_total = lessons_scope.select(:lesson_id).distinct.count
      lessons_completed = lessons_scope.where(status: "completed").count
      lessons_in_progress = lessons_scope.where(status: "started").count

      OpenStruct.new(
        user_id: user_id,
        courses_total: courses_total,
        courses_completed: courses_completed,
        courses_in_progress: courses_in_progress,
        average_progress: average_progress,
        lessons_total: lessons_total,
        lessons_completed: lessons_completed,
        lessons_in_progress: lessons_in_progress
      )
    end
  end
end
