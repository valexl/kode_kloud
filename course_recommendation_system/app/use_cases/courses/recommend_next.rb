module Courses
  class RecommendNext
    def self.call(user_id:)
      excluded = UserCourseProgressRecord.where(user_id: user_id).select(:course_id)
      CourseRecord.where.not(aggregate_id: excluded).order(Arel.sql("RANDOM()")).first
    end
  end
end
