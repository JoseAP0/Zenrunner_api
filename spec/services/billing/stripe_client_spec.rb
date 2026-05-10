require "rails_helper"

RSpec.describe Billing::StripeClient do
  subject(:client) { described_class.new }

  describe "#checkout_sessions" do
    it "returns the stripe checkout session class" do
      expect(client.checkout_sessions).to eq(Stripe::Checkout::Session)
    end
  end

  describe "#construct_webhook_event" do
    let(:payload) { '{"id":"evt_123"}' }
    let(:signature) { "signature" }

    it "delegates webhook verification to stripe" do
      allow(Stripe::Webhook).to receive(:construct_event)

      client.construct_webhook_event(payload:, signature:)

      expect(Stripe::Webhook).to have_received(:construct_event).with(
        payload,
        signature,
        ENV.fetch("STRIPE_WEBHOOK_SECRET")
      )
    end
  end

  describe "#publishable_key" do
    it "returns the configured publishable key" do
      expect(client.publishable_key).to eq(ENV["STRIPE_PUBLISHABLE_KEY"])
    end
  end
end
