RSpec.configure do |config|
  config.before(:each, :rack_attack) do
    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.reset!
  end

  config.after(:each, :rack_attack) do
    Rack::Attack.enabled = true
    Rack::Attack.cache.store = Rails.cache
    Rack::Attack.reset!
  end
end
