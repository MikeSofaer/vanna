require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "rails/test_unit/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"

Bundler.require(:default, Rails.env) if defined?(Bundler)

module ActionPresenter
  class Application < Rails::Application
    config.filter_parameters += [:password]
    config.active_support.deprecation = :stdout
    config.secret_token = '8b9708cd5d4a96f541e04326467fc9c4b0c0a44c4d77b19632db2145fd1cf686d739f7d34a3ecce551c53dc8d31730e816cd332b3eececd95cc539b52e1aadde'
  end
end
