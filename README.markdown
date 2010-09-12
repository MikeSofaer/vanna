Action Presenter

The concept here is that all requests should go through a JSON API before being rendered, without being too much more difficult than standard Rails controllers/views

I decided to go with Handlebars because it was in my RSS reader when I was working on this.

The controller is pretty simple, using the Rails 3 "respond_with" feature.
##WelcomeController
require 'lib/application_presenter'  
class WelcomeController < ApplicationPresenter  
  def index  
    respond_with :text => "hello"  
  end  
end  

The view is a handlebars template
##app/views/welcome/index.html.bar
Here is some text: {{text}}

##HTML output
`Here is some text: hello`

##JSON output
`{"text":"hello"}`

So you are getting a JSON API as a side effect as you build your application.  It can't currently do much more than this, but it's a proof on concept.  Writing webapps this way gives you an API for free, in addition to protecting you from unexpected database access.