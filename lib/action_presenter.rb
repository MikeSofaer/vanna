class ApplicationPresenter < ActionController::Metal
  abstract!
  include ActionView::Context
  lsdjl 
  def lookup_context
    self
  end
end
#
=begin
class ApplicationPresenter < ActionController::Metal
  include ActionController::MimeResponds
  include AbstractController::Rendering
  abstract!

  append_view_path "views"

 
  def controller
    self
  end
 
  DEFAULT_LAYOUT = Object.new.tap {|l| def l.render(*) JsonTemplateRenderer.tag + 
    "<body><div id=main></div></body>"+ yield end }

  def _render_template_from_controller(template, layout = DEFAULT_LAYOUT, options = {}, partial = false)
    template.template = template_string
    ret = template.render(self, options)
    layout.render(self, options) { ret }
  end
  
  respond_to :html, :json
  
  
  def freeze_formats(f); end
  
  def formats; [:html, :json]; end
end
=end
