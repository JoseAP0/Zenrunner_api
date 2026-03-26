require "rails_helper"

RSpec.describe "Auth profile", type: :request do
  describe "GET /api/v1/auth/me" do
    it "returns the authenticated user" do
      user = create(:user)
      token = Auth::TokenIssuer.call(user:)

      get "/api/v1/auth/me", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(json_body.dig("data", "user", "id")).to eq(user.id)
    end

    it "rejects requests without a bearer token" do
      get "/api/v1/auth/me"

      expect(response).to have_http_status(:unauthorized)
      expect(json_body.dig("error", "code")).to eq("unauthorized")
    end

    it "rejects a token after logout rotation" do
      user = create(:user)
      token = Auth::TokenIssuer.call(user:)
      user.increment!(:token_version)

      get "/api/v1/auth/me", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:unauthorized)
      expect(json_body.dig("error", "message")).to eq("Token is no longer valid")
    end
  end
end
