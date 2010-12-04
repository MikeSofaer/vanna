module Vanna
  def self.included(klass)
    raise "#{klass.name} does not inherit from ActionController::Metal" unless klass.ancestors.include?(ActionController::Metal)
    klass.send(:include,  AbstractController::Callbacks)
    klass.send(:include,  AbstractController::Layouts)
    klass.append_view_path "app/views"

    klass.class_eval %{

    html_class_name = self.name + "HTML"
    def logger
      ActionController::Base.logger
    end

    def self.html(&block)
      html_class = Class.new
      html_class.instance_eval &block
      @html_class = html_class
    end
   }
  end

  def process_action(method_name, *args)
    run_callbacks(:process_action, method_name) do
      controller_to_call = self
      controller_response = controller_to_call.send_action(method_name, *args)
      html_class = self.class.instance_variable_get("@html_class".to_sym)
      if request.format.symbol == :html && html_class && html_class.respond_to?(method_name)
        controller_response = html_class.send(method_name, controller_response)
      end

      if controller_response.is_a? Response
        self.status = controller_response.status
        self.location = controller_response.location if controller_response.location
        self.response_body = controller_response.body.to_json
      else
        if request.format.symbol == :html
          raise InvalidDictionary.new("You need to put this in a hash with a name to render it to HTML") unless controller_response.is_a? Hash
          dictionary = @layout_pieces.merge(controller_response) if @layout_pieces
          #block_hash = self.class.instance_variable_get("@post_json_block_hash".to_sym)
          #postprocessor = block_hash[method_name] if block_hash
          #dictionary = postprocessor.call(dictionary) if postprocessor
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
  end
  class Base < ActionController::Metal
    include ActionController::RequestForgeryProtection
    include Vanna
  end

  class Bankrupt < StandardError; end
  class InvalidDictionary < Bankrupt; end
end
