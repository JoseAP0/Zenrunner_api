module Auth
  class TokenIssuer
    def self.call(user:)
      JsonWebToken.encode(
        {
          sub: user.id,
          role: user.role,
          token_version: user.token_version
        }
      )
    end
  end
end
