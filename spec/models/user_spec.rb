require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with factory defaults" do
      expect(build(:user)).to be_valid
    end

    it "normalizes email before validation" do
      user = build(:user, email: "  MIXED@Example.COM  ")

      user.validate

      expect(user.email).to eq("mixed@example.com")
    end

    it "requires a unique email" do
      create(:user, email: "taken@example.com")
      duplicate = build(:user, email: "TAKEN@example.com")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been taken")
    end

    it "requires a password with a minimum length" do
      user = build(:user, password: "short", password_confirmation: "short")

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end
  end

  describe "roles" do
    it "supports admin runner and organizer roles" do
      expect(described_class.roles).to eq("runner" => 0, "organizer" => 1, "admin" => 2)
    end
  end
end
