module Courses
  class CreateCourse

    attr_reader :title, :description, :aggregate_id
    def initialize(title:, description:)
      @title = title
      @description = description
      @aggregate_id = Sequent.new_uuid
    end

    def self.call(title:, description:)
      new(title:, description:).call
    end

    def call
      command = Course::Commands::AddCourse.new(
        aggregate_id: aggregate_id,
        title: title,
        description: description
      )
      Sequent.command_service.execute_commands(command)
      
      result
    end

    private 

    def result
      OpenStruct.new(
        aggregate_id: aggregate_id,
        title: title,
        description: description
      )
    end
  end
end
