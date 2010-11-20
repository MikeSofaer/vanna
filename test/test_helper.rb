ENV["RAILS_ENV"] = "test"
$LOAD_PATH.unshift './test'
$LOAD_PATH.unshift './test/app/controllers'
require 'config/application'
require 'rails/test_help'
require 'json'
require 'wrong'
require 'wrong/adapters/test_unit'
require "wrong/message/string_comparison"
require "rack/test"
Wrong.config[:color] = true
ActionPresenter::Application.initialize!
require 'application_controller'
ApplicationController.append_view_path "test/app/views"
