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
  end
end
