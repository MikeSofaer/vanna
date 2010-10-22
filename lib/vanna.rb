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
    elsif dictionary.is_a? Redirection
      self.status = "302"
      self.location = dictionary.target
      self.response_body = "Over there!"
    else
      raise InvalidDictionary.new("Vanna cannot render objects of type #{dictionary.class} to html.")
    end
  end

  def redirection_to(url)
    Redirection.new(url)
  end

  class Redirection
    attr_accessor :target
    def initialize(target); @target = target; end
    def to_json; {:url => @target}.to_json; end
    def json_status; "201"; end
  end
  class Base < ActionController::Metal
    include ActionController::RequestForgeryProtection
    include Vanna
  end

  class Bankrupt < StandardError; end
  class InvalidDictionary < Bankrupt; end
end
