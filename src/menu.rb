#!/usr/bin/env ruby
#menu.rb


class Menu < ControllerObject
  def initialize(window)
    super()
    @window = window
    @menu_xml = '../interface/menu.xml'
    @box_manager = BoundingBoxManager.new()
    register_buttons()
    @current_boxes_under_mouse = Array.new()
  end
  
  def update()
    @current_boxes_under_mouse = @box_manager.hit_test_boxes(@window.relative_mouse_x, @window.relative_mouse_y)
  end
  
  def register_buttons()
    @box_manager.register_box(XML_Manager['../interface/menu.xml']['new_game']['x'].to_i(),
                              XML_Manager['../interface/menu.xml']['new_game']['y'].to_i(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['new_game']['image']).width(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['new_game']['image']).height(),
                              'new_game')
    @box_manager.register_box(XML_Manager['../interface/menu.xml']['load_game']['x'].to_i(),
                              XML_Manager['../interface/menu.xml']['load_game']['y'].to_i(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['load_game']['image']).width(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['load_game']['image']).height(),
                              'load_game')
    @box_manager.register_box(XML_Manager['../interface/menu.xml']['options']['x'].to_i(),
                              XML_Manager['../interface/menu.xml']['options']['y'].to_i(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['options']['image']).width(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['options']['image']).height(),
                              'options')
    @box_manager.register_box(XML_Manager['../interface/menu.xml']['quit']['x'].to_i(),
                              XML_Manager['../interface/menu.xml']['quit']['y'].to_i(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['quit']['image']).width(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['quit']['image']).height(),
                              'quit')
  end
  
  def draw()
    #Title
    Media::get_image(XML_Manager['../interface/menu.xml']['title']['image']).draw(XML_Manager['../interface/menu.xml']['title']['x'].to_i(), XML_Manager['../interface/menu.xml']['title']['y'].to_i(), 1)
    #Background
    draw_square(@window, 0, 0, 0, 1280, 720, 0xff0000ff)
    #New game button
    box = @box_manager['new_game']
    if @current_boxes_under_mouse.include?('new_game') then
      Media::get_image(XML_Manager['../interface/menu.xml']['new_game']['image_hover']).draw(box.x, box.y, 1)
    else
      Media::get_image(XML_Manager['../interface/menu.xml']['new_game']['image']).draw(box.x, box.y, 1)
    end
    # Load game button
    box = @box_manager['load_game']
    if @current_boxes_under_mouse.include?('load_game') then
      Media::get_image(XML_Manager['../interface/menu.xml']['load_game']['image_hover']).draw(box.x, box.y, 1)
    else
      Media::get_image(XML_Manager['../interface/menu.xml']['load_game']['image']).draw(box.x, box.y, 1)
    end
    # Options button
    box = @box_manager['options']
    if @current_boxes_under_mouse.include?('options') then
      Media::get_image(XML_Manager['../interface/menu.xml']['options']['image_hover']).draw(box.x, box.y, 1)
    else
      Media::get_image(XML_Manager['../interface/menu.xml']['options']['image']).draw(box.x, box.y, 1)
    end
    # Quit button
    box = @box_manager['quit']
    if @current_boxes_under_mouse.include?('quit') then
      Media::get_image(XML_Manager['../interface/menu.xml']['quit']['image_hover']).draw(box.x, box.y, 1)
    else
      Media::get_image(XML_Manager['../interface/menu.xml']['quit']['image']).draw(box.x, box.y, 1)
    end
  end
  
  def button_press_over_id(id, button_id)
    case button_id
      when Gosu::Button::MsLeft
    end
  end
  
  def button_down(id)
    @current_boxes_under_mouse.each do |box_id|
      button_press_over_id(box_id, id)
    end
  end
end

