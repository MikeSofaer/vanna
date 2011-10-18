require './test/test_helper'
require 'weapons_controller'
require 'app/models/weapon'
WeaponsController.append_view_path "test/app/views"

class WaponsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ActionPresenter::Application
  end

  #We want creates to return 201 by default
  def test_creation
    header "Accept", 'application/json'
    post "/weapons/create", {:power => 10, :punch => 32}
    print "last_response.status " + last_response.status.to_s() + "\n"
    print last_response.body + "\n"
    assert ( last_response.status == 201 )
    assert ( JSON(last_response.body)["id"] == 1)
  end

  def test_creation_redirect
    post "/weapons/create", {:power => 10, :punch => 32}
    assert ( last_response.status == 301 )
    assert ( last_response.location == "/weapons/1" )
  end

  def test_update_redirect
    post "/weapons/update", {:weapon => {:id => 1, :power => 100}}
    assert ( last_response.status == 301 )
    assert ( last_response.location == "/weapons" )
  end
end
