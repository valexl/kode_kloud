require "rails_helper"

RSpec.describe Course::Commands::ChangeCourseDescription, type: :command do
  let(:aggregate_id) { Sequent.new_uuid }

  context "validations" do
    it "is valid with description" do
      command = described_class.new(
        aggregate_id: aggregate_id,
        description: "Math for pros"
      )
      expect(command.valid?).to be true
    end

    it "is invalid without description" do
      command = described_class.new(
        aggregate_id: aggregate_id,
        description: ""
      )
      expect(command.valid?).to be false
      expect(command.errors[:description]).to include("can't be blank")
    end
  end
end
