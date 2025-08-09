require "rails_helper"

RSpec.describe Course::Commands::AddCourse, type: :command do
  let(:aggregate_id) { Sequent.new_uuid }

  context "validations" do
    it "is valid with title and description" do
      command = described_class.new(
        aggregate_id: aggregate_id,
        title: "Math 101",
        description: "Basic math course"
      )

      expect(command.valid?).to be true
    end

    it "is invalid without title" do
      command = described_class.new(
        aggregate_id: aggregate_id,
        title: "",
        description: "Basic math course"
      )

      expect(command.valid?).to be false
      expect(command.errors[:title]).to include("can't be blank")
    end

    it "is invalid without description" do
      command = described_class.new(
        aggregate_id: aggregate_id,
        title: "Math 101",
        description: ""
      )

      expect(command.valid?).to be false
      expect(command.errors[:description]).to include("can't be blank")
    end
  end
end
