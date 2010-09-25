#Vanna

Vanna is a proof-of-concept for an opinion that all web requests should operate as logical clients of a JSON API.
This should be transparent to the web developer, and development should still be possible in the standard
pattern of write a test, write the controller code, build a template, repeat.

See [My Blabs post](http://pivotallabs.com/users/msofaer/blog/articles/1423-presenters-and-logical-apis/) for a theoretical discussion.

#Setup:
##Gemfile

    gem 'vanna', :git => 'git://github.com/MikeSofaer/vanna.git'

##ApplicationController

Change ActionController::Base to Vanna::Base

##layouts/application.html.erb

Remove the javascript_include line.  (and if you know what to do to make the helper work, tell me.)

#Usage

##Controllers

Controllers return hashes of the data you want to render.  Don't call render from inside a controller.  If a controller uses params, use (opts=params) in the signature, so it can be called from other controllers.  Use other controller methods to construct the full page dictionary

##Views

Just like normal ERB views, but instead of instance variables, you get the top level hash elements as locals.

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