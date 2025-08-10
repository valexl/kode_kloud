require "rails_helper"

RSpec.describe Courses::DeleteCourse do
  let(:url) { ENV.fetch("INTEGRATION_EVENTS_URL") }

  describe ".call" do
    subject(:call) { described_class.call(course.aggregate_id) }

    let(:course) { create_course! }

    it "publishes course_deleted with correct payload" do
      stub = stub_request(:post, url)
        .with(body: { type: "course_deleted", data: { course_id: course.aggregate_id } }.to_json)
        .to_return(status: 202, body: "", headers: {})

      result = call

      expect(result.aggregate_id).to eq(course.aggregate_id)
      expect(stub).to have_been_requested
    end

    it "marks aggregate as deleted" do
      result = call

      expect(result.aggregate_id).to eq(course.aggregate_id)
      aggregate = Sequent.aggregate_repository.load_aggregate(course.aggregate_id, Course::Course)
      expect(aggregate).not_to be_nil
      expect(aggregate.deleted?).to be true
    end

    it "removes projection" do
      expect {
        call
      }.to change { CourseRecord.where(aggregate_id: course.aggregate_id).count }.by(-1)
    end
  end
end
