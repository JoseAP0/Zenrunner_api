require "stripe"

Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
Stripe.api_version = ENV.fetch("STRIPE_API_VERSION", "2025-02-24.acacia")

if Rails.env.production? && Stripe.api_key.blank?
  raise "Missing STRIPE_SECRET_KEY"
end
