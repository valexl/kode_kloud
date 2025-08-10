require "rails_helper"

RSpec.describe Courses::CreateCourse do
  let(:url) { ENV.fetch("INTEGRATION_EVENTS_URL") }

  describe ".call" do
    subject(:call) { described_class.call(title: "Math", description: "Basics") }

    it "publishes course_added with correct payload" do
      uuid = "00000000-0000-4000-8000-000000000001"
      allow(Sequent).to receive(:new_uuid).and_return(uuid)

      stub = stub_request(:post, url)
        .with { |r| JSON.parse(r.body) == { "type" => "course_added", "data" => { "course_id" => uuid, "title" => "Math", "description" => "Basics" } } }
        .to_return(status: 202, body: "", headers: {})
  
      call
  
      expect(stub).to have_been_requested
    end

    it "persists aggregate" do
      result = call

      expect(result.aggregate_id).to be_present
      expect(result.title).to eq("Math")
      expect(result.description).to eq("Basics")

      aggregate = Sequent.aggregate_repository.load_aggregate(result.aggregate_id, Course::Course)
      expect(aggregate.title).to eq("Math")
      expect(aggregate.description).to eq("Basics")
    end

    it "persists aggregate and projection" do
      result = call

      expect(result.aggregate_id).to be_present
      expect(result.title).to eq("Math")
      expect(result.description).to eq("Basics")

      record = CourseRecord.find_by(aggregate_id: result.aggregate_id)
      expect(record).to be_present
      expect(record.title).to eq("Math")
      expect(record.description).to eq("Basics")
    end    
  end
end
