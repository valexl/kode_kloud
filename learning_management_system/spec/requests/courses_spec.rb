require "rails_helper"

RSpec.describe "Courses API", type: :request do
  describe "POST /lsm/api/v1/courses" do
    it "creates a course and returns 201 with JSON" do
      payload = { course: { title: "Math 101", description: "Basic math course" } }

      post "/lsm/api/v1/courses", params: payload, as: :json

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["id"]).to match(/\A[0-9a-f\-]{36}\z/i)
      expect(body["title"]).to eq("Math 101")
      expect(body["description"]).to eq("Basic math course")
    end

    it "returns 422 on invalid input" do
      payload = { course: { title: "", description: "" } }

      post "/lsm/api/v1/courses", params: payload, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end
  end
end
