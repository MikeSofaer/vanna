gemfile = File.expand_path('../../Gemfile', __FILE__)
begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)
#Bundler.require(:default, Rails.env) if defined?(Bundler)


module ActionPresenter

  class Controller < ApplicationController
    def perform_caching
      false
    end
  end
  
  class Application < Rails::Application
  #  config.action_controller.perfom_caching=0
    @c = Controller.new()
    config.action_controller = @c

#    @c = View.new()
#    config.action_view = @v

    config.active_support.deprecation = :stdout
    config.secret_token = '8b9708cd5d4a96f541e04326467fc9c4b0c0a44c4d77b19632db2145fd1cf686d739f7d34a3ecce551c53dc8d31730e816cd332b3eececd95cc539b52e1aadde'
    routes.draw do
      root :to => "welcome#index"
      match ':controller(/:action(/:id(.:format)))'
    end
    
  end
end
