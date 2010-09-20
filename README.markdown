##Presenter

Presenter is a proof-of-concept for an opinion that all web requests should operate as logical clients of a JSON API.  This should be transparent to the web developer, and development should still be possible in the standard pattern of write a test, write the controller code, build a template, repeat.

There are three principles driving the design choices here:

1)  Logic-free templates.  This has been discussed at length everywhere, but what drives me here is the n-query problem from hidden queries in partials.

2)  Presenter-style testing.  Being able to test the results of a controller call in a declarative way on a hash that represents page layout is much nicer than trying to parse HTML, or introspecting various locals with :assigns

3)  Automatic API.  Building an HTML app should generate a JSON API in the background, with no extra effort.  It should be good by inspection, meaning it cannot get out of sync with the web version.

#Technology Choices
Rails 3 has good routing and template finding, and you can pick and choose pieces of it.
I needed a logic-free template language, and Handlebars showed up in my RSS reader while I was looking.  Chosen "for now"

Presenters should return hashes if they intend to respond with OK.  There should be no explicit render call inside them.  They should be reusable as pieces of larger controller requests.

#WelcomeController
    require './lib/presenter'
    class WelcomeController < Presenter
      def index
        {:text => "hello"}
      end
    end  

The view is a handlebars template
#app/views/welcome/index.html.bar
Here is some text: {{text}}

#HTML output
`Here is some text: hello`

#JSON output
`{"text":"hello"}`

##Data for layouts:
    require './lib/presenter'  
    class ApplicationPresenter < Presenter  
      before_filter :layout_pieces 
      def layout_pieces
        @layout_pieces = {:nav => "nav stuff"}  
      end
    end  

##Complex Presenters
    require './lib/presenter  
    class ComplexController < ApplicationPresenter  
      def index  
        {:main => main, :sidebar => sidebar}  
      end  
      def main  
        {:complexities => Complexity.all}  
      end  
      def sidebar  
        {:advertisements => Advertisement.for(current_user)  
      end  
    end  

As a side effect of this model, you can call main and sidebar as explicit JSON methods and get those pieces of data.  This unifies your data presentation chain.