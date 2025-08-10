module Lesson
   class Lesson < Sequent::AggregateRoot
    
    attr_reader :course_id, :title, :description, :deleted
    def initialize(command)
      super(command.aggregate_id)
      apply Events::LessonAdded, 
                title: command.title, 
                description: command.description, 
                course_id: command.course_id
    end

    def deleted?
      !!@deleted
    end

    def change_title(command)
      return if @title == command.title

      apply Events::LessonTitleChanged, title: command.title
    end

    def change_description(command)
      return if @description == command.description

      apply Events::LessonDescriptionChanged, description: command.description
    end

    def change_course(command)
      return if @course_id == command.course_id

      apply Events::LessonCourseChanged, course_id: command.course_id
    end

    def delete
      return if @deleted
      apply Events::LessonDeleted
    end

    on Events::LessonAdded do |event|
      @title = event.title
      @description = event.description
      @course_id = event.course_id
    end

    on Events::LessonTitleChanged do |event|
      @title = event.title
    end

    on Events::LessonDescriptionChanged do |event|
      @description = event.description
    end

    on Events::LessonDeleted do
      @deleted = true
    end
  end
end