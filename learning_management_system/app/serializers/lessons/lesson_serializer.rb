module Lessons
  class LessonSerializer
    def self.call(lesson)
      {
        id: lesson.aggregate_id,
        course_id: lesson.course_id,
        title: lesson.title,
        description: lesson.description
      }
    end
  end
end
