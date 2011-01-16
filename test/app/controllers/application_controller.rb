require './lib/vanna'
class ApplicationController < Vanna::Base
  include Vanna
  before_filter :setup_layout

  def setup_layout
    @layout_pieces = {:nav => "Nav bar here", :footer => "My page is so cool."}
  end
end
