require "rails_helper"

RSpec.describe Student::StudentCommandHandler, type: :command_handler do
  include Sequent::Test::CommandHandlerHelpers

  let(:aggregate_id) { Sequent.new_uuid }

  before do
    Sequent.configuration.command_handlers = [described_class.new]
  end

  it "creates a student and publishes StudentCreated" do
    when_command Student::Commands::CreateStudent.new(aggregate_id:)
    then_events Student::Events::StudentCreated
  end

  it "deletes a student and publishes StudentDeleted" do
    given_events Student::Events::StudentCreated.new(
      aggregate_id: aggregate_id,
      sequence_number: 1,
      created_at: Time.now
    )
    when_command Student::Commands::DeleteStudent.new(aggregate_id:)
    then_events Student::Events::StudentDeleted
  end
end
