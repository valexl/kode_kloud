module Lessons
  class LessonsSerializer
    def self.call(lessons)
      lessons.map do |lesson|
        LessonSerializer.call(lesson)
      end
    end
  end
end
