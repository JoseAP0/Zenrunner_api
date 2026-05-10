RSpec.configure do |config|
  config.before(:suite) do
    Rack::Attack.enabled = false
  end

  config.around(:each, :rack_attack) do |example|
    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.reset!

    example.run
  ensure
    Rack::Attack.enabled = false
    Rack::Attack.cache.store = Rails.cache
    Rack::Attack.reset!
  end
end
