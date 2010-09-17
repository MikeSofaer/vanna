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
    respond_with(send_action(method_name, *args))
  end

end
module ActionController
  class Responder
    protected
    def default_render
      controller.response_body = request.format.symbol == :json ?
        options.to_json : controller.render(nil, :dictionary => options)
    end
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
%{<div id=main>
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
=begin
class ApplicationPresenter < ActionController::Metal


  include ActionView::Context
  def _render_template_from_controller(template, layout = DEFAULT_LAYOUT, options = {}, partial = false)
    template.template = template_string
    ret = template.render(self, options)
    layout.render(self, options) { ret }
  end
 
  DEFAULT_LAYOUT = Object.new.tap {|l| def l.render(*) JsonTemplateRenderer.tag + 
    "<body><div id=main></div></body>"+ yield end }

  
end
=end
