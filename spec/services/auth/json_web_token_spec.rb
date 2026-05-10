require "rails_helper"

RSpec.describe Auth::JsonWebToken do
  describe ".encode/.decode" do
    it "encodes and decodes the payload" do
      token = described_class.encode({ sub: "user-id", token_version: 0 })

      payload = described_class.decode(token)

      expect(payload).to include("sub" => "user-id", "token_version" => 0)
      expect(payload["exp"]).to be_present
    end

    it "raises an authentication error for expired tokens" do
      token = described_class.encode({ sub: "user-id", token_version: 0 }, expires_at: 1.hour.ago)

      expect { described_class.decode(token) }
        .to raise_error(Auth::AuthenticationError, "Token has expired")
    end

    it "requires an explicit jwt secret in production" do
      original_jwt_secret = ENV.delete("JWT_SECRET")
      allow(Rails.env).to receive(:production?).and_return(true)

      expect { described_class.encode({ sub: "user-id", token_version: 0 }) }
        .to raise_error(RuntimeError, "Missing JWT_SECRET")
    ensure
      ENV["JWT_SECRET"] = original_jwt_secret if original_jwt_secret
    end

    it "uses the jwt secret from env in production" do
      original_jwt_secret = ENV["JWT_SECRET"]
      ENV["JWT_SECRET"] = "production-jwt-secret"
      allow(Rails.env).to receive(:production?).and_return(true)

      token = described_class.encode({ sub: "user-id", token_version: 0 })

      expect(described_class.decode(token))
        .to include("sub" => "user-id", "token_version" => 0)
    ensure
      if original_jwt_secret
        ENV["JWT_SECRET"] = original_jwt_secret
      else
        ENV.delete("JWT_SECRET")
      end
    end
  end
end
