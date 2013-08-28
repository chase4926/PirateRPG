#!/usr/bin/env ruby
#menu.rb


class Menu < ControllerObject
  def initialize(window)
    super()
    @window = window
    @menu_xml = '../interface/menu.xml'
    @box_manager = BoundingBoxManager.new()
    register_buttons()
    @phase = 0 # 0 = Main menu, 1 = Load game, 2 = Options 
    @current_boxes_under_mouse = Array.new()
  end
  
  def update()
    @current_boxes_under_mouse = @box_manager.hit_test_boxes(@window.relative_mouse_x, @window.relative_mouse_y)
  end
  
  def register_buttons()
    @box_manager.register_box(XML_Manager['../interface/menu.xml']['main']['new_game']['x'].to_i(),
                              XML_Manager['../interface/menu.xml']['main']['new_game']['y'].to_i(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['main']['new_game']['image']).width(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['main']['new_game']['image']).height(),
                              'new_game')
    @box_manager.register_box(XML_Manager['../interface/menu.xml']['main']['load_game']['x'].to_i(),
                              XML_Manager['../interface/menu.xml']['main']['load_game']['y'].to_i(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['main']['load_game']['image']).width(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['main']['load_game']['image']).height(),
                              'load_game')
    @box_manager.register_box(XML_Manager['../interface/menu.xml']['main']['options']['x'].to_i(),
                              XML_Manager['../interface/menu.xml']['main']['options']['y'].to_i(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['main']['options']['image']).width(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['main']['options']['image']).height(),
                              'options')
    @box_manager.register_box(XML_Manager['../interface/menu.xml']['main']['quit']['x'].to_i(),
                              XML_Manager['../interface/menu.xml']['main']['quit']['y'].to_i(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['main']['quit']['image']).width(),
                              Media::get_image(XML_Manager['../interface/menu.xml']['main']['quit']['image']).height(),
                              'quit')
  end
  
  def draw()
    #Title
    Media::get_image(XML_Manager['../interface/menu.xml']['title']['image']).draw(XML_Manager['../interface/menu.xml']['title']['x'].to_i(), XML_Manager['../interface/menu.xml']['title']['y'].to_i(), 1)
    #Background
    draw_square(@window, 0, 0, 0, 1280, 720, 0xff1c6ba0)
    #New game button
    box = @box_manager['new_game']
    if @current_boxes_under_mouse.include?('new_game') then
      Media::get_image(XML_Manager['../interface/menu.xml']['main']['new_game']['image_hover']).draw(box.x, box.y, 1)
    else
      Media::get_image(XML_Manager['../interface/menu.xml']['main']['new_game']['image']).draw(box.x, box.y, 1)
    end
    # Load game button
    box = @box_manager['load_game']
    if @current_boxes_under_mouse.include?('load_game') then
      Media::get_image(XML_Manager['../interface/menu.xml']['main']['load_game']['image_hover']).draw(box.x, box.y, 1)
    else
      Media::get_image(XML_Manager['../interface/menu.xml']['main']['load_game']['image']).draw(box.x, box.y, 1)
    end
    # Options button
    box = @box_manager['options']
    if @current_boxes_under_mouse.include?('options') then
      Media::get_image(XML_Manager['../interface/menu.xml']['main']['options']['image_hover']).draw(box.x, box.y, 1)
    else
      Media::get_image(XML_Manager['../interface/menu.xml']['main']['options']['image']).draw(box.x, box.y, 1)
    end
    # Quit button
    box = @box_manager['quit']
    if @current_boxes_under_mouse.include?('quit') then
      Media::get_image(XML_Manager['../interface/menu.xml']['main']['quit']['image_hover']).draw(box.x, box.y, 1)
    else
      Media::get_image(XML_Manager['../interface/menu.xml']['main']['quit']['image']).draw(box.x, box.y, 1)
    end
    if @phase == 2 then
      #Options Background
      Media::get_image(XML_Manager['../interface/menu.xml']['options']['background']['image']).draw(XML_Manager['../interface/menu.xml']['options']['background']['x'].to_i(), XML_Manager['../interface/menu.xml']['options']['background']['y'].to_i(), 1)
    end
  end
  
  def button_press_over_id(id, button_id)
    case button_id
      when Gosu::Button::MsLeft
        case id
          #when 'new_game'
          #when 'load_game'
          when 'options'
            if @phase == 0 then
              # if on main menu, open options menu
              @phase = 2
            else
              # if on options menu, close it
              @phase = 0
            end
          when 'quit'
            @window.close()
        end
    end
  end
  
  def button_down(id)
    @current_boxes_under_mouse.each do |box_id|
      button_press_over_id(box_id, id)
    end
  end
end

