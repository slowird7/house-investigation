require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HouseInvestigation
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    # Permit cross origin
    #config.middleware.insert_before 0, Rack::Cors do
    #  allow do
    #    origins '*'
    #    resource '*', headers: :any, methods: [:get, :post, :options]
    #  end
    #end    
    # Permit cross origin
    
    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Credentials' => 'true',
      'Access-Control-Allow-Origin' => 'http://localhost:3355',
      'Access-Control-Request-Method' => '*'
    }
    
    config.autoload_paths << Rails.root.join("lib")
  end
end
