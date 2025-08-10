RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, ENV["INTEGRATION_EVENTS_URL"]).to_return(status: 202, body: "", headers: {})
  end
end
