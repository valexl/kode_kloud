module Progresses
  class LessonProgressSerializer
    def self.call(result)
      {
        lesson_id: result.lesson_id,
        user_id:   result.user_id,
        status:    result.status
      }
    end
  end
end