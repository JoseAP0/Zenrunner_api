module Billing
  class StripeConfiguration
    REQUIRED_KEYS = %w[
      STRIPE_SECRET_KEY
      STRIPE_PUBLISHABLE_KEY
      STRIPE_WEBHOOK_SECRET
    ].freeze

    def self.missing_keys
      REQUIRED_KEYS.select { |key| ENV[key].blank? }
    end

    def self.configured?
      missing_keys.empty?
    end
  end
end
