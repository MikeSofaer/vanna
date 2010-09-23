#Vanna

Vanna is a proof-of-concept for an opinion that all web requests should operate as logical clients of a JSON API.
This should be transparent to the web developer, and development should still be possible in the standard
pattern of write a test, write the controller code, build a template, repeat.

There are three principles driving the design choices here:

1)  Explicit choice about what goes into the views.  It's been my experience that people don't do enough
of this in controllers, and wind up having things like n-query problems in their views.

2)  Presenter-style testing.  Being able to test the results of a controller call in a declarative way on a hash that represents page layout is much nicer than trying to parse HTML, or introspecting various locals with :assigns

3)  Automatic API.  Building an HTML app should generate a JSON API in the background, with no extra effort.  It should be good by inspection, meaning it cannot get out of sync with the web version.

#Technology Choices
Rails 3 has good routing and template finding, and you can pick and choose pieces of it.
I would like to make this more compatible with logic-free templates on the server side, but this
turned out to be hard, so I am using ERB by default.

Presenters should return hashes if they intend to respond with OK.  There should be no explicit render call inside them.  They should be reusable as pieces of larger controller requests.

#WelcomeController
    require './lib/vanna'
    class WelcomeController < ActionController::Metal
      include Vanna
      def index
        {:text => "hello"}
      end
    end  

The view is a basic ERB template.  No instance variables, you get the top keys as locals:
#app/views/welcome/index.html.erb
`Here is some text: <%=text%>`

#HTML output
`Here is some text: hello`

#JSON output
`{"text":"hello"}`

##Data for layouts:
Here I didn't come up with a good way to avoid instance variables, so the @layout_pieces gets merged
in in the controller flow
    require './lib/vanna'  
    class ApplicationPresenter < ActionController::Metal
      include Vanna
      before_filter :layout_pieces
      def layout_pieces
        @layout_pieces = {:nav => "nav stuff"}  
      end
    end  

##Complex Controllers
    class PersonasController < ApplicationController
      def index
        {:main => {"personas" => Persona.all}}
      end
      def show(opts = params)
        persona = Persona.named(opts["persona"]).first
        sidebar = friend_catchphrases("personas" => persona["partners"])
        {:main => {:persona =>persona, :sidebar => sidebar}}
      end
      def friend_catchphrases(opts=params)
        names = opts["personas"]
        Persona.named(names).map{|p| p["catchphrase"]}
      end
    end 
As a side effect of this model, you can call main and sidebar as explicit JSON methods and get those pieces
of data.  This unifies your data presentation chain.  So just building the sidebar for your webpage makes
it available on its own for JSON calls for mobile or AJAX
