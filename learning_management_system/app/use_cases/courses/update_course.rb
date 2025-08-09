module Courses
  class UpdateCourse

    attr_reader :title, :description, :aggregate_id
    def initialize(aggregate_id:, title:, description:)
      @title = title
      @description = description
      @aggregate_id = aggregate_id
    end

    def self.call(aggregate_id:, title:, description:)
      new(aggregate_id:, title:, description:).call
    end

    def call
      Sequent.command_service.execute_commands(*commands)
      
      result
    end

    private

    def commands
      [
        Course::Commands::ChangeCourseTitle.new(
          aggregate_id: aggregate_id,
          title: title
        ),
        Course::Commands::ChangeCourseDescription.new(
          aggregate_id: aggregate_id,
          description: description
        ),
      ]
    end

    def result
      OpenStruct.new(
        aggregate_id: aggregate_id,
        title: title,
        description: description
      )
    end
  end
end
