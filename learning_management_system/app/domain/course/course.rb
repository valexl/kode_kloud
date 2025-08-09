module Course
   class Course < Sequent::AggregateRoot

    def initialize(command)
      super(command.aggregate_id)
      apply Events::CourseAdded
      apply Events::CourseTitleChanged, title: command.title
      apply Events::CourseDescriptionChanged, description: command.description
    end

    def deleted?
      !!@deleted
    end

    def change_title(command)
      return if @title == command.title

      apply Events::CourseTitleChanged, title: command.title
    end

    def change_description(command)
      return if @description == command.description

      apply Events::CourseDescriptionChanged, description: command.description
    end

    def delete
      return if @deleted
      apply Events::CourseDeleted
    end

    on Events::CourseAdded do |_|
    end

    on Events::CourseTitleChanged do |event|
      @title = event.title
    end

    on Events::CourseDescriptionChanged do |event|
      @description = event.description
    end

    on Events::CourseDeleted do
      @deleted = true
    end
  end
end