RSpec.configure do |config|
  config.include Sequent::Test::CommandHandlerHelpers, type: :command_handler

  config.before(:each, type: :command_handler) do
    Sequent.configure do |cfg|
      cfg.event_store = Sequent::Test::CommandHandlerHelpers::FakeEventStore.new
      cfg.command_handlers = []
      cfg.event_handlers = []
    end
  end
end
