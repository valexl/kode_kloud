require "rails_helper"

RSpec.describe Course::CourseCommandHandler, type: :command_handler do
  include Sequent::Test::CommandHandlerHelpers

  let(:aggregate_id) { Sequent.new_uuid }

  before do
    Sequent.configure do |config|
      config.event_store = Sequent::Test::CommandHandlerHelpers::FakeEventStore.new
      config.command_handlers = [described_class.new]
      config.event_handlers = []
    end
  end

  it "creates a course and publishes CourseAdded" do
    when_command Course::Commands::AddCourse.new(
      aggregate_id: aggregate_id,
      title: "Math 101",
      description: "Basic math course"
    )

    then_events Course::Events::CourseAdded, Course::Events::CourseTitleChanged, Course::Events::CourseDescriptionChanged
  end
end
