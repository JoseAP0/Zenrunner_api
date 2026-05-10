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

    it "rate limits repeated attempts from the same email", :rack_attack do
      5.times do
        post "/api/v1/auth/login",
          params: { session: { email: "ALICE@example.com", password: "wrong-password" } },
          as: :json
      end

      post "/api/v1/auth/login",
        params: { session: { email: "alice@example.com", password: "wrong-password" } },
        as: :json

      expect(response).to have_http_status(:too_many_requests)
      expect(response.headers["Retry-After"]).to eq("300")
      expect(json_body.dig("error", "code")).to eq("rate_limited")
    end

    it "rate limits repeated attempts from the same ip", :rack_attack do
      10.times do |index|
        post "/api/v1/auth/login",
          params: { session: { email: "user-#{index}@example.com", password: "wrong-password" } },
          as: :json
      end

      post "/api/v1/auth/login",
        params: { session: { email: "another-user@example.com", password: "wrong-password" } },
        as: :json

      expect(response).to have_http_status(:too_many_requests)
      expect(response.headers["Retry-After"]).to eq("60")
      expect(json_body.dig("error", "code")).to eq("rate_limited")
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
