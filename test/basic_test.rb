require './test/test_helper'
require 'welcome_controller'
WelcomeController.append_view_path "test/app/views"

class BasicTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ActionPresenter::Application
  end

  def test_gets_json
    header "Accept", 'application/json'
    get "/"
    assert{ JSON(last_response.body) == {"text" => "hello"} }
  end
  def test_html_renders_template
    get "/"
    assert{ last_response.body =~  /Here is some text: hello/ }
  end
end

