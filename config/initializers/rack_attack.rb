require "rack/attack"

Rack::Attack.cache.store = Rails.cache
Rack::Attack.enabled = false if Rails.env.test?

Rack::Attack.throttled_responder = lambda do |request|
  match_data = request.env["rack.attack.match_data"] || {}
  retry_after = match_data[:period].to_i

  [
    429,
    {
      "Content-Type" => "application/json",
      "Retry-After" => retry_after.to_s
    },
    [
      {
        error: {
          code: "rate_limited",
          message: "Too many requests. Please try again later."
        }
      }.to_json
    ]
  ]
end

Rack::Attack.throttle("auth/login/ip", limit: 10, period: 1.minute) do |request|
  request.ip if request.post? && request.path == "/api/v1/auth/login"
end

Rack::Attack.throttle("auth/login/email", limit: 5, period: 5.minutes) do |request|
  if request.post? && request.path == "/api/v1/auth/login"
    raw_body = request.body.read
    request.body.rewind

    params = JSON.parse(raw_body)
    params.dig("session", "email").to_s.strip.downcase.presence
  end
rescue JSON::ParserError
  nil
end

Rack::Attack.throttle("auth/register/ip", limit: 5, period: 1.hour) do |request|
  request.ip if request.post? && request.path == "/api/v1/auth/register"
end
