module Progress
  module Commands
    class StartLesson < Sequent::Command
      attrs lesson_id: String, course_id: String
    end
    
    class CompleteLesson < Sequent::Command
      attrs lesson_id: String, course_id: String
    end
    
    class StartCourse < Sequent::Core::Command
      attrs course_id: String
    end

    class SetCourseProgress < Sequent::Command
      attrs course_id: String, progress: Integer
    end
  end
end