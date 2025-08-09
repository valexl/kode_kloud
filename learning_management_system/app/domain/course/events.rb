module Course
  module Events
    class CourseAdded < Sequent::Event; end

    class CourseTitleChanged < Sequent::Event
      attrs title: String
    end
    
    class CourseDescriptionChanged < Sequent::Event
      attrs description: String
    end
  end
end