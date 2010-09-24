require './lib/vanna'
class WelcomeController < ActionController::Metal
  include Vanna
  def index
    {:text => "hello"}    
  end
end
