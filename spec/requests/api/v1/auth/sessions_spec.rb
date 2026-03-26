require "rails_helper"

RSpec.describe "Auth sessions", type: :request do
  let!(:user) { create(:user, email: "alice@example.com", password: "Password123", password_confirmation: "Password123") }

  describe "POST /api/v1/auth/login" do
    it "returns a jwt token for valid credentials" do
      post "/api/v1/auth/login",
        params: { session: { email: "alice@example.com", password: "Password123" } },
        as: :json

      expect(response).to have_http_status(:ok)
      expect(json_body.dig("data", "user", "id")).to eq(user.id)
      expect(json_body.dig("data", "token")).to be_present
    end

    it "rejects invalid credentials" do
      post "/api/v1/auth/login",
        params: { session: { email: "alice@example.com", password: "wrong-password" } },
        as: :json

      expect(response).to have_http_status(:unauthorized)
      expect(json_body.dig("error", "code")).to eq("invalid_credentials")
    end
  end

  describe "DELETE /api/v1/auth/logout" do
    it "invalidates the current token by rotating token_version" do
      token = Auth::TokenIssuer.call(user:)

      expect do
        delete "/api/v1/auth/logout", headers: { "Authorization" => "Bearer #{token}" }
      end.to change { user.reload.token_version }.by(1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
