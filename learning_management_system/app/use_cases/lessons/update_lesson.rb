module Lessons
  class UpdateLesson

    attr_reader :title, :description, :aggregate_id, :course_id
    def initialize(aggregate_id:, title:, description:, course_id:)
      @title = title
      @description = description
      @aggregate_id = aggregate_id
      @course_id = course_id
    end

    def self.call(aggregate_id:, title:, description:, course_id:)
      new(aggregate_id:, title:, description:, course_id:).call
    end

    def call
      Sequent.command_service.execute_commands(*commands)
      
      result
    end

    private

    def commands
      [
        Lesson::Commands::ChangeLessonTitle.new(
          aggregate_id: aggregate_id,
          title: title
        ),
        Lesson::Commands::ChangeLessonDescription.new(
          aggregate_id: aggregate_id,
          description: description
        ),
        Lesson::Commands::ChangeLessonCourse.new(
          aggregate_id: aggregate_id,
          course_id: course_id
        )
      ]
    end

    def result
      OpenStruct.new(
        aggregate_id: aggregate_id,
        course_id: course_id,
        title: title,
        description: description
      )
    end
  end
end
