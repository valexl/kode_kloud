module Lessons
  class CreateLesson

    attr_reader :title, :description, :aggregate_id, :course_id
    def initialize(title:, description:, course_id:)
      @title = title
      @description = description
      @aggregate_id = Sequent.new_uuid
      @course_id = course_id
    end

    def self.call(title:, description:, course_id:)
      new(title:, description:, course_id:).call
    end

    def call
      Sequent.command_service.execute_commands(*commands)
      
      result
    end

    private

    def commands
      [
        Lesson::Commands::AddLesson.new(
          aggregate_id: aggregate_id,
          course_id: course_id,
          title: title,
          description: description
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
