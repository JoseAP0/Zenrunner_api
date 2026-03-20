module Auth
  class JsonWebToken
    ALGORITHM = "HS256"
    DEFAULT_EXPIRATION = 24.hours

    def self.encode(payload, expires_at: DEFAULT_EXPIRATION.from_now)
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

    private_class_method :secret_key
  end
end
