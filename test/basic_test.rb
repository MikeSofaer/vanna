require './test/test_helper'
require 'welcome_controller'
#require 'wrong' #
#require "wrong/message/string_comparison"
require 'pp' #
#include Wrong

WelcomeController.append_view_path "test/app/views"

class BasicTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ActionPresenter::Application
  end

  def test_gets_json
    header "Accept", 'application/json'
    get "/"
    x = JSON(last_response.body)
#    pp x
    y = {"text" => "hello"}
#    pp x == y
    assert  x == y
  end
  def test_html_renders_template
    get "/"
    assert (last_response.body =~  /Here is some text: hello/ )
  end
end

