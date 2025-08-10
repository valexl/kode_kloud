module Course
  module Events
    class CourseAdded < Sequent::Event
      attrs title: String, description: String
    end

    class CourseDeleted < Sequent::Event
    end
  end
end
