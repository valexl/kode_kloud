require "rails_helper"

RSpec.describe Course::Commands::ChangeCourseTitle, type: :command do
  let(:aggregate_id) { Sequent.new_uuid }

  context "validations" do
    it "is valid with title" do
      command = described_class.new(
        aggregate_id: aggregate_id,
        title: "Advanced Math"
      )
      expect(command.valid?).to be true
    end

    it "is invalid without title" do
      command = described_class.new(
        aggregate_id: aggregate_id,
        title: ""
      )
      expect(command.valid?).to be false
      expect(command.errors[:title]).to include("can't be blank")
    end
  end
end
