RSpec.configure do |config|
  config.include Sequent::Test::CommandHandlerHelpers, type: :command_handler

  config.around(:each, type: :command_handler) do |example|
    original_event_store = Sequent.configuration.event_store
    original_command_handlers = Sequent.configuration.command_handlers.dup
    original_event_handlers = Sequent.configuration.event_handlers.dup

    Sequent.configure do |cfg|
      cfg.event_store = Sequent::Test::CommandHandlerHelpers::FakeEventStore.new
      cfg.command_handlers = []
      cfg.event_handlers = []
    end

    example.run

    Sequent.configure do |cfg|
      cfg.event_store = original_event_store
      cfg.command_handlers = original_command_handlers
      cfg.event_handlers = original_event_handlers
    end
  end
end


module SequentHelpers
  module FactoryHelpers
    def create_course!(aggregate_id: nil, title: "Math 101", description: "Basic math course")
      aggregate_id ||= Sequent.new_uuid
      Sequent.command_service.execute_commands(
        Course::Commands::AddCourse.new(aggregate_id:, title:, description:)
      )

      OpenStruct.new(
        aggregate_id:,
        title:,
        description:
      )
    end
  end
end