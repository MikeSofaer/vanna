module Vanna
  def self.included(klass)
    raise "#{klass.name} does not inherit from ActionController::Metal" unless klass.ancestors.include?(ActionController::Metal)
    klass.send(:include,  AbstractController::Layouts)
    klass.send(:include,  AbstractController::Callbacks)
    klass.append_view_path "app/views"

    klass.class_eval("def logger; ActionController::Base.logger; end;")
  end

  def process_action(method_name, *args)
    run_callbacks(:process_action, method_name) do
      dictionary = send_action(method_name, *args)
      dictionary = @layout_pieces.merge(dictionary) if @layout_pieces && dictionary.is_a?(Hash) && request.format.symbol != :json
      if request.format.symbol == :json
        self.response_body = dictionary.to_json
        self.status = dictionary.json_status if dictionary.respond_to?(:json_status)
      else
        html_render(dictionary)
      end
    end
  end
  def html_render(dictionary)
    if dictionary.is_a? Hash
      render(nil, :locals => dictionary)
    elsif dictionary.is_a? Response
      self.status = dictionary.html_status 
      self.location = dictionary.target if dictionary.html_status=~ /3\d\d/
      self.response_body = dictionary.html_body
    else
      raise InvalidDictionary.new("Vanna cannot render objects of type #{dictionary.class} to html.")
    end
  end

  def CreationFailure(options)
    Response.new(options.merge(:json_status => "422", :json_body => "Invalid", :html_status => "302"))
  end

  def CreationSuccess(options)
    Response.new(options.merge(:json_status => "201", :html_status => "302"))
  end

  class Response
    def initialize(options); @options = options; end
    def to_json
      @options[:json_body] ||
        {:url => @options[:redirect_to]}.to_json
    end
    def html_body
      @options[:html_body] || ""
    end
    def target; @options[:redirect_to]; end
    def json_status; @options[:json_status]; end
    def html_status; @options[:html_status]; end
  end
  class Base < ActionController::Metal
    include ActionController::RequestForgeryProtection
    include Vanna
  end

  class Bankrupt < StandardError; end
  class InvalidDictionary < Bankrupt; end
end
