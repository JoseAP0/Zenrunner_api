require "rails_helper"

RSpec.describe Billing::StripeConfiguration do
  describe ".missing_keys" do
    it "returns no keys when stripe env config is present" do
      expect(described_class.missing_keys).to eq([])
    end
  end

  describe ".configured?" do
    it "is true when all required stripe keys are present" do
      expect(described_class.configured?).to be(true)
    end
  end
end
