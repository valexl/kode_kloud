module Stats
  class UserStatsSerializer
    def self.call(stats)
      {
        user_id: stats[:user_id],
        courses: {
          total: stats[:courses_total],
          completed: stats[:courses_completed],
          in_progress: stats[:courses_in_progress],
          average_progress: stats[:average_progress]
        },
        lessons: {
          total: stats[:lessons_total],
          completed: stats[:lessons_completed],
          in_progress: stats[:lessons_in_progress]
        }
      }
    end
  end
end
