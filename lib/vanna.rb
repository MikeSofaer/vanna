module Vanna
  def self.included(klass)
    raise "#{klass.name} does not inherit from ActionController::Metal" unless klass.ancestors.include?(ActionController::Metal)
    klass.send(:include,  AbstractController::Callbacks)
    klass.send(:include,  AbstractController::Layouts)
    klass.append_view_path "app/views"

    klass.class_eval %{
    def logger
      ActionController::Base.logger
    end

    def self.html(post_json_block_hash)
      @post_json_block_hash = post_json_block_hash
    end
    def self.Redirection(options)
      options[:target] = options.delete(:to)
      options[:status] ||= 302
      Response.new(options)
    end
    }
  end

  def process_action(method_name, *args)
    run_callbacks(:process_action, method_name) do
      dictionary = send_action(method_name, *args)

      if request.format.symbol == :json
        self.response_body = dictionary.to_json
        self.status = dictionary.status if dictionary.respond_to?(:status)
      else
        dictionary = @layout_pieces.merge(dictionary) if @layout_pieces && dictionary.is_a?(Hash)
        block_hash = self.class.instance_variable_get("@post_json_block_hash".to_sym)
        postprocessor = block_hash[method_name] if block_hash
        dictionary = postprocessor.call(dictionary) if postprocessor
        html_render(dictionary)
      end
    end
  end
  def html_render(dictionary)
    if dictionary.is_a? Hash
      render(nil, :locals => dictionary)
    elsif dictionary.is_a? Response
      self.status = dictionary.status
      if dictionary.target
        self.location = dictionary.target
        self.response_body = "Redirected!"
      else
        self.response_body = dictionary.body if dictionary.body
      end
    else
      raise InvalidDictionary.new("Vanna cannot render objects of type #{dictionary.class} to html.")
    end
  end

  def CreationFailure(options)
    Response.new({:status => 422, :body => {:message => "Invalid"}}.merge options)
  end

  def CreationSuccess(options)
    Response.new(options.merge(:status => 201))
  end


  class Response
    def initialize(options); @options = options; end
    def status; @options[:status]; end
    def target; @options[:target]; end
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
