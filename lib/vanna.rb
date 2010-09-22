module Vanna
  def self.included(klass)
    raise "#{klass.name} does not inherit from ActionController::Metal" unless klass.ancestors.include?(ActionController::Metal)
    klass.send(:include,  AbstractController::Callbacks)
    klass.send(:include,  AbstractController::Layouts)
    klass.append_view_path "app/views"
  end

  def process_action(method_name, *args)
    run_callbacks(:process_action, method_name) do
      dictionary = send_action(method_name, *args)
	  dictionary = @layout_pieces.merge(dictionary) if @layout_pieces && dictionary.is_a?(Hash)
      self.response_body = request.format.symbol == :json ?
        dictionary.to_json : html_render(dictionary)
    end
  end
  def html_render(dictionary)
    render(nil, :locals => dictionary)
  end
end
