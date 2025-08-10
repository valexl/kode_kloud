module Course
   class Course < Sequent::AggregateRoot

    def initialize(command)
      super(command.aggregate_id)
      apply Events::CourseAdded, title: command.title, description: command.description
    end

    def deleted?
      !!@deleted
    end

    def delete
      return if @deleted
      apply Events::CourseDeleted
    end

    on Events::CourseAdded do |event|
      @title = event.title
      @description = event.description
    end

    on Events::CourseDeleted do
      @deleted = true
    end
  end
end