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
    @bounding_box_manager.register_box(XML_Manager['../interface/menu.xml']['load_game']['x'].to_i(),
                                       XML_Manager['../interface/menu.xml']['load_game']['y'].to_i(),
                                       Media::get_image(XML_Manager['../interface/menu.xml']['load_game']['image']).width(),
                                       Media::get_image(XML_Manager['../interface/menu.xml']['load_game']['image']).height(),
                                       'load_game')
    @bounding_box_manager.register_box(XML_Manager['../interface/menu.xml']['options']['x'].to_i(),
                                       XML_Manager['../interface/menu.xml']['options']['y'].to_i(),
                                       Media::get_image(XML_Manager['../interface/menu.xml']['options']['image']).width(),
                                       Media::get_image(XML_Manager['../interface/menu.xml']['options']['image']).height(),
                                       'options')
    @bounding_box_manager.register_box(XML_Manager['../interface/menu.xml']['quit']['x'].to_i(),
                                       XML_Manager['../interface/menu.xml']['quit']['y'].to_i(),
                                       Media::get_image(XML_Manager['../interface/menu.xml']['quit']['image']).width(),
                                       Media::get_image(XML_Manager['../interface/menu.xml']['quit']['image']).height(),
                                       'quit')
  end
  
  def draw()
    #New game button
    box = @bounding_box_manager['new_game']
    Media::get_image(XML_Manager['../interface/menu.xml']['new_game']['image']).draw(box.x, box.y, 1)
    # Load game button
    box = @bounding_box_manager['load_game']
    Media::get_image(XML_Manager['../interface/menu.xml']['load_game']['image']).draw(box.x, box.y, 1)
    # Options button
    box = @bounding_box_manager['options']
    Media::get_image(XML_Manager['../interface/menu.xml']['options']['image']).draw(box.x, box.y, 1)
    # Quit button
    box = @bounding_box_manager['quit']
    Media::get_image(XML_Manager['../interface/menu.xml']['quit']['image']).draw(box.x, box.y, 1)
  end
end

