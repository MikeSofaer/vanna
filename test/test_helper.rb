ENV["RAILS_ENV"] = "test"
$LOAD_PATH.unshift './test'
$LOAD_PATH.unshift './test/app/controllers'
require 'rubygems'
gem 'minitest' # ensures you're using the gem, and not the built in MT
require 'minitest/autorun'
gem 'test-unit'
require 'test/unit'
require 'wrong/adapters/test_unit'

require 'config/application'
require 'rails/test_help'
require 'json'
require 'wrong'
require "wrong/message/string_comparison"
require "rack/test"
Wrong.config[:color] = true
ActionPresenter::Application.initialize!
require 'application_controller'
ApplicationController.append_view_path "test/app/views"
require 'pp'
