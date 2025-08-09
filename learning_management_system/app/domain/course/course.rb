module Course
   class Course < Sequent::AggregateRoot
    def initialize(command)
      super(command.aggregate_id)
      apply Events::CourseAdded
      apply Events::CourseTitleChanged, title: command.title
      apply Events::CourseDescriptionChanged, description: command.description
    end

    on Events::CourseAdded do |_|
    end

    on Events::CourseTitleChanged do |event|
      @title = event.title
    end

    on Events::CourseDescriptionChanged do |event|
      @description = event.description
    end
  end
end