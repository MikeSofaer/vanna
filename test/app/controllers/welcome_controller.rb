require './lib/vanna'
class WelcomeController < ActionController::Metal
  include Vanna
  def index
    {:text => "hello"}
  end
  def create
    candy = {:show_url => "/link_to_candy"} #Model created from post data
    new_resource(candy[:show_url])
  end
end
