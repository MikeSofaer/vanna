require 'action_controller'
require 'vanna/default_return_codes'
require 'vanna/default_redirects'
module Vanna
  def self.included(klass)
    raise "#{klass.name} does not inherit from ActionController::Metal" unless klass.ancestors.include?(ActionController::Metal)
    klass.send(:include,  AbstractController::Callbacks)
    klass.send(:include,  AbstractController::Layouts)
    klass.append_view_path "app/views"

    klass.class_eval do
      def logger
        ActionController::Base.logger
      end

      def self.post_processors
        @post_processors ||= {}
      end

      def self.post_process(symbol, &block)
        pclass = post_processors[symbol] ||= Class.new(self)
        pclass.class_eval &block
      end
    end
  end

  def process_action(method_name, *args)
    run_callbacks(:process_action, method_name) do
      controller_response = send_action(method_name, *args)
      pp_method = ("post_" + method_name.to_s).to_sym

      post_processor_class = self.class.post_processors[request.format.symbol]
      if post_processor_class
        post_processor = post_processor_class.new
        if post_processor.respond_to?(pp_method)
          controller_response = post_processor.send(pp_method, controller_response)
        end
      end

      if controller_response.is_a? Response
        self.status = controller_response.status
        self.location = controller_response.location if controller_response.location
        self.response_body = controller_response.to_json
      else
        if request.format.symbol == :html
          raise InvalidDictionary.new("You need to put this in a hash with a name to render it to HTML") unless controller_response.is_a? Hash
          dictionary = if @layout_pieces
                         @layout_pieces.merge(controller_response)
                       else
                         controller_response
                       end
          render(nil, :locals => dictionary)
        else
          self.response_body = controller_response.to_json
        end
      end
    end
  end

  class Response
    def initialize(options); @options = options; end
    def status; @options[:status]; end
    def location; @options[:location]; end
    def body; @options[:body]; end
    def to_json; body.to_json; end
    def [](key); body[key]; end
  end
  class Base < ActionController::Metal
    include ActionController::RequestForgeryProtection
    include Vanna
    include AbstractController::AssetPaths
    include ActionController::Helpers
    self.javascripts_dir = "javascripts"
    self.assets_dir = "public"
    
    def self.inherited(subclass)
      super
      subclass.send(:include, DefaultReturnCodes) unless subclass.ancestors.member? DefaultReturnCodes
      subclass.send(:include, DefaultRedirects) unless subclass.ancestors.member? DefaultRedirects
      subclass.send(:include, Rails.application.routes.url_helpers)
    end
  end

  class InvalidDictionary < StandardError; end
end
