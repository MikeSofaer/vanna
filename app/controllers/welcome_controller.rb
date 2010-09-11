require 'lib/application_presenter'
class WelcomeController < ApplicationPresenter

def index
  @view_paths =  ["app/views"]
  respond_with :text => "hello"
end

end
