#!/usr/bin/env ruby
#menu.rb


class Menu < ControllerObject
  def initialize(window)
    super()
    @window = window
    @menu_xml = '../interface/menu.xml'
    @bounding_box_manager = BoundingBoxManager.new()
    register_buttons()
  end
  
  def register_buttons()
    @bounding_box_manager.register_box(XML_Manager['../interface/menu.xml']['new_game']['x'].to_i(),
                                       XML_Manager['../interface/menu.xml']['new_game']['y'].to_i(),
                                       Media::get_image(XML_Manager['../interface/menu.xml']['new_game']['image']).width(),
                                       Media::get_image(XML_Manager['../interface/menu.xml']['new_game']['image']).height(),
                                       'new_game')
  end
  
  def draw()
    #New game button
    box = @bounding_box_manager['new_game']
    Media::get_image(XML_Manager['../interface/menu.xml']['new_game']['image']).draw(box.x, box.y, 1)
  end
end

