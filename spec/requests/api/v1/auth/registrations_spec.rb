require "rails_helper"

RSpec.describe "Auth registration", type: :request do
  describe "POST /api/v1/auth/register" do
    let(:params) do
      {
        user: {
          name: "Alice Runner",
          email: "alice@example.com",
          password: "Password123",
          password_confirmation: "Password123",
          role: "runner"
        }
      }
    end

    it "creates a user and returns a jwt token" do
      expect do
        post "/api/v1/auth/register", params:, as: :json
      end.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json_body.dig("data", "user", "email")).to eq("alice@example.com")
      expect(json_body.dig("data", "token")).to be_present
    end

    it "returns validation errors for invalid data" do
      post "/api/v1/auth/register",
        params: { user: params[:user].merge(email: "", password_confirmation: "mismatch") },
        as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(json_body.dig("error", "code")).to eq("validation_error")
    end
  end
end
