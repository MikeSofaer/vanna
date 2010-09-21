require './lib/vanna'
class WelcomeController < Vanna
  def index
    {:text => "hello"}    
  end
end
