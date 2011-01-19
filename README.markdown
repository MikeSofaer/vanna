#Vanna

Vanna is a replacement for ActionController::Base, build around the basic concept that all web requests should operate as logical clients of a JSON API.
This should be transparent to the web developer, and development should still be possible in the standard
pattern of write a test, write the controller code, build a template, repeat.

The main differences are:

- controllers return their data directly
- controllers are tested by calling them directly
- html-specific behavior (like redirects) happen in explicit post-process blocks

See [My Blabs post](http://pivotallabs.com/users/msofaer/blog/articles/1423-presenters-and-logical-apis/) for a theoretical discussion.

#Setup:
##Gemfile

    gem 'vanna', :git => 'git://github.com/MikeSofaer/vanna.git'

##ApplicationController

Change 'ActionController::Base' to 'Vanna::Base'

#Usage

##Controllers

Controllers normally return hashes of the data you want to render.  Don't call render from inside a controller.  If a controller uses params, use (opts=params) in the signature, so it can be called from other controllers.  Use other controller methods to construct the full page dictionary

##Views

Just like normal ERB views, but instead of instance variables, you get the top level hash elements as locals, so all templates act like partials.

Since there are no instance variables, anything that needs to be available in a partial has to be passed through.

#Example

##Controller

    class PersonasController < ApplicationController
      def index
        {:main => {"personas" => Persona.all}}
      end
      def show(opts = params)
        persona = Persona.named(opts["persona"]).first
        sidebar = catchphrases("personas" => persona["partners"])
        {:persona =>persona, :sidebar => sidebar}
      end
      def catchphrases(opts=params)
        names = opts["personas"]
        Persona.named(names).map{|p| p["catchphrase"]}
      end
    end
