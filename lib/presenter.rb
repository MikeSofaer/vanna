class Presenter < ActionController::Metal
  abstract!
  include ActionController::MimeResponds
  include AbstractController::Rendering
  append_view_path "app/views"
  
  #These are just here to stop errors, they do nothing
  respond_to :html, :json
  def freeze_formats(f); end
  def formats; [:html, :json]; end
 
  def logger
    ActionController::Base.logger
  end

  def process_action(method_name, *args)
    dictionary = send_action(method_name, *args)
    self.response_body = request.format.symbol == :json ?
      dictionary.to_json : render(nil, :dictionary => dictionary)
  end
end

module ::ActionView
  module TemplateHandlers
    class Handlebars < TemplateHandler
      def self.call(template)
        template.source
      end
    end
  end
  module Rendering
    def _render_template(template, layout = nil, options = {})
%{<div id=main></div>
  <script src='javascripts/handlebars.js'></script>
  <script type="text/javascript"> 
    var template = Handlebars.compile("#{template.source.gsub(/\s/, " ")}");
        var dictionary = #{options[:dictionary].to_json}
    document.getElementById('main').innerText=template(dictionary, {});
  </script>
}      
    end
  end
end
::ActionView::Template.register_template_handler(:bar, ::ActionView::TemplateHandlers::Handlebars)
