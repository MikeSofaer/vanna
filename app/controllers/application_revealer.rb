require './lib/vanna'
class ApplicationRevealer < Vanna
  before_filter :setup_layout
  
  def setup_layout
    @layout_pieces = {"nav" => "Nav bar here", "footer" => "My page is so cool."}
  end
end
