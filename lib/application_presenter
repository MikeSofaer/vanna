class ApplicationPresenter < ActionController::Metal
  abstract!
#  def formats; [:html, :json]; end
  include ActionController::MimeResponds  
  respond_to :html, :json

  def formats=(rspec_wants_this);end
  def url_options;{};end
end
#
=begin
class ApplicationPresenter < ActionController::Metal
  include ActionController::MimeResponds
  include ActionView::Context
  include AbstractController::Rendering
  abstract!

  append_view_path "views"

  def lookup_context
    self
  end
 
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
