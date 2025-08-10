module Lesson
  module Events
    class LessonAdded < Sequent::Event
      attrs title: String, description: String, course_id: String
    end
    class LessonDeleted < Sequent::Event; end

    class LessonTitleChanged < Sequent::Event
      attrs title: String
    end
    
    class LessonDescriptionChanged < Sequent::Event
      attrs description: String
    end

    class LessonCourseChanged < Sequent::Event
      attrs course_id: String
    end
  end
end