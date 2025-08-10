require "net/http"

class HttpIntegrationEventPublisher
  def initialize(url:)
    @url = url
  end

  def publish(type:, data:)
    request.body = JSON.dump({ type: type, data: data })
    http.request(request)
    true
  end

  private

  def uri
    @uri ||= URI.parse(@url)
  end

  def http
    @http ||= begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http
    end
  end

  def request
    @request ||= Net::HTTP::Post.new(
      uri.request_uri,
      { "Content-Type" => "application/json" }
    )
  end
end
