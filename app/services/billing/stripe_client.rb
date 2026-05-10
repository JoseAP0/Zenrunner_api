module Billing
  class StripeClient
    def checkout_sessions
      ::Stripe::Checkout::Session
    end

    def construct_webhook_event(payload:, signature:)
      ::Stripe::Webhook.construct_event(
        payload,
        signature,
        ENV.fetch("STRIPE_WEBHOOK_SECRET")
      )
    end

    def publishable_key
      ENV["STRIPE_PUBLISHABLE_KEY"]
    end
  end
end
