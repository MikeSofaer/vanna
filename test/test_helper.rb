ENV["RAILS_ENV"] = "test"
$LOAD_PATH.unshift './test'
$LOAD_PATH.unshift './test/app/controllers'
 # for application_controller
require 'rubygems'
#gem 'minitest' # ensures you're using the gem, and not the built in MT
#gem 'test-unit'
#gem 'wrong'

#require 'minitest'
#require 'minitest/autorun'
require 'test/unit'
require 'rails'
require 'bundler'


#require 'rails/test_help'
require 'json'
#require 'wrong' #
#require "wrong/message/string_comparison"
#require 'wrong/adapters/test_unit' ##You are using MiniTest's compatibility layer, not the real Test::Unit.
#require "action_controller/railtie"

require "rack/test"
require 'application_controller'

require 'config/application'

#Wrong.config[:color] = true
require 'pp'

#pp ActionPresenter
#pp ActionPresenter::Application
ActionPresenter::Application.initialize!
ApplicationController.append_view_path "test/app/views"

