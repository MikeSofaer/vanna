Action Presenter

The concept here is that all requests should go through a JSON API before being rendered, without being too much more difficult than standard Rails controllers/views

I decided to go with Handlebars because it was in my RSS reader when I was working on this.

##WelcomeController
`require 'lib/application_presenter'
class WelcomeController < ApplicationPresenter
  def index
    respond_with :text => "hello"
  end
end`

##app/views/welcome/index.html.bar
`Here is some text: {{text}}`

##HTML output
`Here is some test: hello`

##JSON output
`{"text":"hello"}`

It can't currently do much more than this, but it's a proof on concept.  Writing webapps this way gives you an API for free, in addition to protecting you from unexpected database access.