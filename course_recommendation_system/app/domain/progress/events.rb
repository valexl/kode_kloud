module Progress
  module Events
    class CourseStarted < Sequent::Event
      attrs user_id: String, course_id: String
    end

    class CourseCompleted < Sequent::Event
      attrs user_id: String, course_id: String
    end  
  end
end