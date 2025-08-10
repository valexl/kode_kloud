require "rails_helper"

RSpec.describe HttpIntegrationEventPublisher do
  describe "#publish" do
    subject(:publish) { publisher.publish(type: event_type, data: event_data) }

    let(:event_type) { "course_added" }
    let(:event_data) { { course_id: "cid", title: "T", description: "D" } }
    let(:publisher)  { described_class.new(url: url) }

    context "when http" do
      let(:url) { "http://integration-sink.test/api/v1/lms-events" }

      it "posts JSON and returns true" do
        stub = stub_request(:post, url)
          .with(
            headers: { "Content-Type" => "application/json" },
            body: { type: event_type, data: event_data }.to_json
          )
          .to_return(status: 202, body: "", headers: {})

        expect(publish).to eq(true)
        expect(stub).to have_been_requested
      end

      it "returns true on non-2xx" do
        stub_request(:post, url).to_return(status: 500, body: "", headers: {})
        expect(publish).to eq(true)
      end

      it "can publish multiple times with the same instance" do
        stub = stub_request(:post, url).to_return(status: 202, body: "", headers: {})
        publisher.publish(type: "a", data: {})
        publisher.publish(type: "b", data: {})
        expect(stub).to have_been_requested.twice
      end
    end

    context "when https" do
      let(:url) { "https://integration.example.com/api/v1/lms-events" }

      it "posts JSON over https and returns true" do
        stub = stub_request(:post, url).to_return(status: 202, body: "", headers: {})
        expect(publish).to eq(true)
        expect(stub).to have_been_requested
      end

      it "returns true on non-2xx https" do
        stub_request(:post, url).to_return(status: 503, body: "", headers: {})
        expect(publish).to eq(true)
      end
    end
  end
end
