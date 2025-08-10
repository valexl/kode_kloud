module Lessons
  class DeleteLesson

    attr_reader :aggregate_id
    def initialize(aggregate_id:)
      @aggregate_id = aggregate_id
    end

    def self.call(aggregate_id)
      new(aggregate_id:).call
    end

    def call
      Sequent.command_service.execute_commands(*commands)
      
      result
    end

    private

    def commands
      [
        Lesson::Commands::DeleteLesson.new(aggregate_id: aggregate_id)
      ]
    end

    def result
      OpenStruct.new(
        aggregate_id: aggregate_id,
      )
    end
  end
end
