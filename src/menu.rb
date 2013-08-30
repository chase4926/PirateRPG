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
    @resolutions = get_resolution_list()
    update_resolution_index()
  end
  
  def update()
    @current_boxes_under_mouse = @box_manager.hit_test_boxes(@window.relative_mouse_x, @window.relative_mouse_y)
    if @current_boxes_under_mouse.include?('volume') and @window.button_down?(Gosu::Button::MsLeft) then
      # Modify volume
      Res::Vars['volume'] = (((@window.relative_mouse_x - Res::XML.int(@menu_xml, '//volume/slider/x')) / Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/background')).width()) * 100).round()
    end
  end
  
  def get_resolution_list()
    result = Array.new()
    Res::XML[@menu_xml].xpath('//resolutions/resolution').each() do |res|
      result << [res.xpath('./width').text().to_i(), res.xpath('./height').text().to_i()]
    end
    return result
  end
  
  def update_resolution_index()
    @resolution_index = get_resolution_index()
  end
  
  def get_resolution_index()
    return @resolutions.index(Res::Vars['resolution'])
  end
  
  def register_buttons()
    # New game button
    @box_manager.register_image(Res::XML.int(@menu_xml, '//main/new_game/x'),
                                Res::XML.int(@menu_xml, '//main/new_game/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//main/new_game/image')),
                                'new_game')
    @box_manager['new_game'].extra = Media::get_image(Res::XML.text(@menu_xml, '//main/new_game/image_hover'))
    # Load game button
    @box_manager.register_image(Res::XML.int(@menu_xml, '//main/load_game/x'),
                                Res::XML.int(@menu_xml, '//main/load_game/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//main/load_game/image')),
                                'load_game')
    @box_manager['load_game'].extra = Media::get_image(Res::XML.text(@menu_xml, '//main/load_game/image_hover'))
    # Options button
    @box_manager.register_image(Res::XML.int(@menu_xml, '//main/options/x'),
                                Res::XML.int(@menu_xml, '//main/options/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//main/options/image')),
                                'options')
    @box_manager['options'].extra = Media::get_image(Res::XML.text(@menu_xml, '//main/options/image_hover'))
    # Quit button
    @box_manager.register_image(Res::XML.int(@menu_xml, '//main/quit/x'),
                                Res::XML.int(@menu_xml, '//main/quit/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//main/quit/image')),
                                'quit')
    @box_manager['quit'].extra = Media::get_image(Res::XML.text(@menu_xml, '//main/quit/image_hover'))
    # Volume slider
    @box_manager.register_image(Res::XML.int(@menu_xml, '//volume/slider/x'),
                                Res::XML.int(@menu_xml, '//volume/slider/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/background')),
                                'volume')
    # Left arrow
    @box_manager.register_image(Res::XML.int(@menu_xml, '//resolution/left_arrow/x'),
                                Res::XML.int(@menu_xml, '//resolution/left_arrow/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//resolution/left_arrow/image')),
                                'left_arrow')
    # Right arrow
    @box_manager.register_image(Res::XML.int(@menu_xml, '//resolution/right_arrow/x'),
                                Res::XML.int(@menu_xml, '//resolution/right_arrow/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//resolution/right_arrow/image')),
                                'right_arrow')
    # Apply button
    @box_manager.register_image(Res::XML.int(@menu_xml, '//options/apply/x'),
                                Res::XML.int(@menu_xml, '//options/apply/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//options/apply/image')),
                                'apply')
    @box_manager['apply'].extra = Media::get_image(Res::XML.text(@menu_xml, '//options/apply/image_hover'))
    # Defaults button
    @box_manager.register_image(Res::XML.int(@menu_xml, '//options/defaults/x'),
                                Res::XML.int(@menu_xml, '//options/defaults/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//options/defaults/image')),
                                'defaults')
    @box_manager['defaults'].extra = Media::get_image(Res::XML.text(@menu_xml, '//options/defaults/image_hover'))
  end
  
  def draw()
    # Title
    Media::get_image(Res::XML.text(@menu_xml, '/menu/title/image')).draw(Res::XML.int(@menu_xml, '/menu/title/x'), Res::XML.int(@menu_xml, '/menu/title/y'), 1)
    # Background
    draw_square(@window, 0, 0, 0, 1280, 720, 0xff1c6ba0)
    # New game button
    box = @box_manager['new_game']
    if @current_boxes_under_mouse.include?('new_game') then
      box.extra.draw(box.x, box.y, 1)
    else
      box.image.draw(box.x, box.y, 1)
    end
    # Load game button
    box = @box_manager['load_game']
    if @current_boxes_under_mouse.include?('load_game') then
      box.extra.draw(box.x, box.y, 1)
    else
      box.image.draw(box.x, box.y, 1)
    end
    # Options button
    box = @box_manager['options']
    if @current_boxes_under_mouse.include?('options') then
      box.extra.draw(box.x, box.y, 1)
    else
      box.image.draw(box.x, box.y, 1)
    end
    # Quit button
    box = @box_manager['quit']
    if @current_boxes_under_mouse.include?('quit') then
      box.extra.draw(box.x, box.y, 1)
    else
      box.image.draw(box.x, box.y, 1)
    end
    if @phase == 2 then
      # Options background
      Media::get_image(Res::XML.text(@menu_xml, '//options/background/image')).draw(Res::XML.int(@menu_xml, '//options/background/x'), Res::XML.int(@menu_xml, '//options/background/y'), 1)
      # Sound slider
      @options_font.draw(Res::XML.text(@menu_xml, '//volume/text/text'), Res::XML.int(@menu_xml, '//volume/text/x'), Res::XML.int(@menu_xml, '//volume/text/y'), 2)
      @box_manager['volume'].image.draw(@box_manager['volume'].x, @box_manager['volume'].y, 2)
      @options_font.draw("#{Res::Vars['volume']}%", Res::XML.int(@menu_xml, '//volume/percentage/x'), Res::XML.int(@menu_xml, '//volume/percentage/y'), 2)
      Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/image')).draw(((Res::Vars['volume'] / 100.0) * 240) + Res::XML.int(@menu_xml, '//volume/slider/x') - (Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/image')).width() / 2), Res::XML.int(@menu_xml, '//volume/slider/y') + (Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/image')).height() / 2), 3)
      # Apply button
      box = @box_manager['apply']
      if @current_boxes_under_mouse.include?('apply') then
        box.extra.draw(box.x, box.y, 1)
      else
        box.image.draw(box.x, box.y, 1)
      end
      # Defaults button
      box = @box_manager['defaults']
      if @current_boxes_under_mouse.include?('defaults') then
        box.extra.draw(box.x, box.y, 1)
      else
        box.image.draw(box.x, box.y, 1)
      end
      # Resolution changer
      @options_font.draw(Res::XML.text(@menu_xml, '//resolution/title/text'), Res::XML.int(@menu_xml, '//resolution/title/x'), Res::XML.int(@menu_xml, '//resolution/title/y'), 2)
      @options_font.draw("#{@resolutions[@resolution_index][0]}x#{@resolutions[@resolution_index][1]}", Res::XML.int(@menu_xml, '//resolution/text/x'), Res::XML.int(@menu_xml, '//resolution/text/y'), 2)
      box = @box_manager['left_arrow']
      box.image.draw(box.x, box.y, 2)
      box = @box_manager['right_arrow']
      box.image.draw(box.x, box.y, 2)
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
              when 'defaults'
                #Reset config to defaults
                Res::Vars.defaults()
                Res::Vars.save()
                update_resolution_index()
              when 'left_arrow'
                Res::Vars['resolution'] = @resolutions[(get_resolution_index() - 1) % @resolutions.count()]
                update_resolution_index()
              when 'right_arrow'
                Res::Vars['resolution'] = @resolutions[(get_resolution_index() + 1) % @resolutions.count()]
                update_resolution_index()
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

