require "rack/test"
require 'test/test_helper'
require 'json'
require 'wrong'
require 'wrong/adapters/test_unit'
require "wrong/message/string_diff"
Wrong.config[:color] = true


class BasicTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ActionPresenter::Application
  end

  def test_index_lists_personas
    header "Accept", 'application/json'
    demo_hash = {"name" => "The Fire Eater", "catchphrase" => "Hungry like the volcano!", "photo_url" => "example.com/img/fire_eater_photo"}
    create_persona demo_hash
    get "/personas"
    assert{ JSON(last_response.body).keys.sort == ["nav", "main", "footer"].sort }
    assert{ JSON(last_response.body)["main"]["personas"].first == demo_hash }
  end
end

def create_persona(options)
  PersonasSerializer.add(options)
end
