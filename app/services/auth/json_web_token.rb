module Auth
  class JsonWebToken
    ALGORITHM = "HS256"

    def self.encode(payload, expires_at: expiration_window.from_now)
      JWT.encode(payload.merge(exp: expires_at.to_i), secret_key, ALGORITHM)
    end

    def self.decode(token)
      decoded_token = JWT.decode(token, secret_key, true, algorithm: ALGORITHM)
      decoded_token.first
    rescue JWT::ExpiredSignature
      raise AuthenticationError, "Token has expired"
    rescue JWT::DecodeError
      raise AuthenticationError, "Invalid token"
    end

    def self.secret_key
      ENV["JWT_SECRET"] || Rails.application.credentials.secret_key_base || Rails.application.secret_key_base
    end

    def self.expiration_window
      ENV.fetch("JWT_EXPIRATION_HOURS", 24).to_i.hours
    end

    private_class_method :secret_key
    private_class_method :expiration_window
  end
end
