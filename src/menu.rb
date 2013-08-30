#!/usr/bin/env ruby
#menu.rb


class Menu < ControllerObject
  def initialize(window)
    super()
    @window = window
    @menu_xml = '../interface/menu.xml'
    @options_font = Res::Font[Res::XML.text(@menu_xml, '//options/font/name'), Res::XML.int(@menu_xml, '//options/font/size')]
    @box_manager = BoundingBoxManager.new()
    register_buttons()
    @phase = 0 # 0 = Main menu, 1 = Load game, 2 = Options 
    @current_boxes_under_mouse = Array.new()
  end
  
  def update()
    @current_boxes_under_mouse = @box_manager.hit_test_boxes(@window.relative_mouse_x, @window.relative_mouse_y)
    if @current_boxes_under_mouse.include?('volume') and @window.button_down?(Gosu::Button::MsLeft) then
      # Modify volume
      Res::Vars['volume'] = (((@window.relative_mouse_x - Res::XML.int(@menu_xml, '//volume/slider/x')) / Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/background')).width()) * 100).round()
    end
  end
  
  def register_buttons()
    @box_manager.register_box(Res::XML.int(@menu_xml, '//main/new_game/x'),
                              Res::XML.int(@menu_xml, '//main/new_game/y'),
                              Media::get_image(Res::XML.text(@menu_xml, '//main/new_game/image')).width(),
                              Media::get_image(Res::XML.text(@menu_xml, '//main/new_game/image')).height(),
                              'new_game')
    @box_manager.register_box(Res::XML.int(@menu_xml, '//main/load_game/x'),
                              Res::XML.int(@menu_xml, '//main/load_game/y'),
                              Media::get_image(Res::XML.text(@menu_xml, '//main/load_game/image')).width(),
                              Media::get_image(Res::XML.text(@menu_xml, '//main/load_game/image')).height(),
                              'load_game')
    @box_manager.register_box(Res::XML.int(@menu_xml, '//main/options/x'),
                              Res::XML.int(@menu_xml, '//main/options/y'),
                              Media::get_image(Res::XML.text(@menu_xml, '//main/options/image')).width(),
                              Media::get_image(Res::XML.text(@menu_xml, '//main/options/image')).height(),
                              'options')
    @box_manager.register_box(Res::XML.int(@menu_xml, '//main/quit/x'),
                              Res::XML.int(@menu_xml, '//main/quit/y'),
                              Media::get_image(Res::XML.text(@menu_xml, '//main/quit/image')).width(),
                              Media::get_image(Res::XML.text(@menu_xml, '//main/quit/image')).height(),
                              'quit')
    @box_manager.register_box(Res::XML.int(@menu_xml, '//volume/slider/x'),
                              Res::XML.int(@menu_xml, '//volume/slider/y'),
                              Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/background')).width(),
                              Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/background')).height(),
                              'volume')
    @box_manager.register_box(Res::XML.int(@menu_xml, '//options/apply/x'),
                              Res::XML.int(@menu_xml, '//options/apply/y'),
                              Media::get_image(Res::XML.text(@menu_xml, '//options/apply/image')).width(),
                              Media::get_image(Res::XML.text(@menu_xml, '//options/apply/image')).height(),
                              'apply')
  end
  
  def draw()
    # Title
    Media::get_image(Res::XML.text(@menu_xml, '//title/image')).draw(Res::XML.int(@menu_xml, '//title/x'), Res::XML.int(@menu_xml, '//title/y'), 1)
    # Background
    draw_square(@window, 0, 0, 0, 1280, 720, 0xff1c6ba0)
    # New game button
    box = @box_manager['new_game']
    if @current_boxes_under_mouse.include?('new_game') then
      Media::get_image(Res::XML.text(@menu_xml, '//main/new_game/image_hover')).draw(box.x, box.y, 1)
    else
      Media::get_image(Res::XML.text(@menu_xml, '//main/new_game/image')).draw(box.x, box.y, 1)
    end
    # Load game button
    box = @box_manager['load_game']
    if @current_boxes_under_mouse.include?('load_game') then
      Media::get_image(Res::XML.text(@menu_xml, '//main/load_game/image_hover')).draw(box.x, box.y, 1)
    else
      Media::get_image(Res::XML.text(@menu_xml, '//main/load_game/image')).draw(box.x, box.y, 1)
    end
    # Options button
    box = @box_manager['options']
    if @current_boxes_under_mouse.include?('options') then
      Media::get_image(Res::XML.text(@menu_xml, '//main/options/image_hover')).draw(box.x, box.y, 1)
    else
      Media::get_image(Res::XML.text(@menu_xml, '//main/options/image')).draw(box.x, box.y, 1)
    end
    # Quit button
    box = @box_manager['quit']
    if @current_boxes_under_mouse.include?('quit') then
      Media::get_image(Res::XML.text(@menu_xml, '//main/quit/image_hover')).draw(box.x, box.y, 1)
    else
      Media::get_image(Res::XML.text(@menu_xml, '//main/quit/image')).draw(box.x, box.y, 1)
    end
    if @phase == 2 then
      # Options background
      Media::get_image(Res::XML.text(@menu_xml, '//options/background/image')).draw(Res::XML.int(@menu_xml, '//options/background/x'), Res::XML.int(@menu_xml, '//options/background/y'), 1)
      # Sound slider
      @options_font.draw(Res::XML.text(@menu_xml, '//volume/text/text'), Res::XML.int(@menu_xml, '//volume/text/x'), Res::XML.int(@menu_xml, '//volume/text/y'), 2)
      Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/background')).draw(Res::XML.int(@menu_xml, '//volume/slider/x'), Res::XML.int(@menu_xml, '//volume/slider/y'), 2)
      @options_font.draw("#{Res::Vars['volume']}%", Res::XML.int(@menu_xml, '//volume/percentage/x'), Res::XML.int(@menu_xml, '//volume/percentage/y'), 2)
      Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/image')).draw(((Res::Vars['volume'] / 100.0) * 240) + Res::XML.int(@menu_xml, '//volume/slider/x') - (Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/image')).width() / 2), Res::XML.int(@menu_xml, '//volume/slider/y') + (Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/image')).height() / 2), 3)
      # Apply button
      box = @box_manager['apply']
      if @current_boxes_under_mouse.include?('apply') then
        Media::get_image(Res::XML.text(@menu_xml, '//options/apply/image_hover')).draw(box.x, box.y, 1)
      else
        Media::get_image(Res::XML.text(@menu_xml, '//options/apply/image')).draw(box.x, box.y, 1)
      end
    end
  end
  
  def button_press_over_id(id, button_id)
    case button_id
      when Gosu::Button::MsLeft
        case @phase
          when 0 # Main menu
            case id
              #when 'new_game'
              #when 'load_game'
              when 'options'
                #Open the options menu
                @phase = 2
              when 'quit'
                #Quit the game
                @window.close()
            end
          when 2 # Options menu
            case id
              when 'options'
                #Close options menu
                @phase = 0
              when 'quit'
                #Quit the game
                @window.close()
              when 'apply'
                #Save config changes
                Res::Vars.save()
            end
        end
    end
  end
  
  def button_down(id)
    @current_boxes_under_mouse.each do |box_id|
      button_press_over_id(box_id, id)
    end
  end
end

