module Progress
  module Events
    class LessonStarted < Sequent::Event
      attrs user_id: String, lesson_id: String, course_id: String, started_at: Time
    end

    class LessonCompleted < Sequent::Event
      attrs user_id: String, lesson_id: String, course_id: String, completed_at: Time
    end

    class CourseStarted < Sequent::Event
      attrs user_id: String, course_id: String
    end

    class CourseProgressUpdated < Sequent::Event
      attrs user_id: String, course_id: String, progress: Integer
    end  
  end
end
