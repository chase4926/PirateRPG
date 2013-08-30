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
    # Resolution Left arrow
    @box_manager.register_image(Res::XML.int(@menu_xml, '//resolution/left_arrow/x'),
                                Res::XML.int(@menu_xml, '//resolution/left_arrow/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//resolution/left_arrow/image')),
                                'resolution_left_arrow')
    # Resolution Right arrow
    @box_manager.register_image(Res::XML.int(@menu_xml, '//resolution/right_arrow/x'),
                                Res::XML.int(@menu_xml, '//resolution/right_arrow/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//resolution/right_arrow/image')),
                                'resolution_right_arrow')
    # Fullscreen Left arrow
    @box_manager.register_image(Res::XML.int(@menu_xml, '//fullscreen/left_arrow/x'),
                                Res::XML.int(@menu_xml, '//fullscreen/left_arrow/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//fullscreen/left_arrow/image')),
                                'fullscreen_left_arrow')
    # Fullscreen Right arrow
    @box_manager.register_image(Res::XML.int(@menu_xml, '//fullscreen/right_arrow/x'),
                                Res::XML.int(@menu_xml, '//fullscreen/right_arrow/y'),
                                Media::get_image(Res::XML.text(@menu_xml, '//fullscreen/right_arrow/image')),
                                'fullscreen_right_arrow')
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
  
  def draw_button(id)
    box = @box_manager[id]
    if @current_boxes_under_mouse.include?(id) then
      box.extra.draw(box.x, box.y, 2)
    else
      box.image.draw(box.x, box.y, 2)
    end
  end
  
  def draw()
    # Background
    20.times() do |x|
      12.times() do |y|
        Media::get_image('ocean.png').draw(x*64, y*64, 1)
      end
    end
    # Title
    Media::get_image(Res::XML.text(@menu_xml, '/menu/title/image')).draw(Res::XML.int(@menu_xml, '/menu/title/x'), Res::XML.int(@menu_xml, '/menu/title/y'), 1)
    # New game button
    draw_button('new_game')
    # Load game button
    draw_button('load_game')
    # Options button
    draw_button('options')
    # Quit button
    draw_button('quit')
    if @phase == 2 then # Options menu
      # Options background
      Media::get_image(Res::XML.text(@menu_xml, '//options/background/image')).draw(Res::XML.int(@menu_xml, '//options/background/x'), Res::XML.int(@menu_xml, '//options/background/y'), 1)
      # Sound slider
      @options_font.draw(Res::XML.text(@menu_xml, '//volume/text/text'), Res::XML.int(@menu_xml, '//volume/text/x'), Res::XML.int(@menu_xml, '//volume/text/y'), 2)
      @box_manager['volume'].image.draw(@box_manager['volume'].x, @box_manager['volume'].y, 2)
      @options_font.draw("#{Res::Vars['volume']}%", Res::XML.int(@menu_xml, '//volume/percentage/x'), Res::XML.int(@menu_xml, '//volume/percentage/y'), 2)
      Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/image')).draw(((Res::Vars['volume'] / 100.0) * 240) + Res::XML.int(@menu_xml, '//volume/slider/x') - (Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/image')).width() / 2), Res::XML.int(@menu_xml, '//volume/slider/y') + (Media::get_image(Res::XML.text(@menu_xml, '//volume/slider/image')).height() / 2), 3)
      # Apply button
      draw_button('apply')
      # Defaults button
      draw_button('defaults')
      # Resolution changer
      @options_font.draw(Res::XML.text(@menu_xml, '//resolution/title/text'), Res::XML.int(@menu_xml, '//resolution/title/x'), Res::XML.int(@menu_xml, '//resolution/title/y'), 2)
      @options_font.draw("#{@resolutions[@resolution_index][0]}x#{@resolutions[@resolution_index][1]}", Res::XML.int(@menu_xml, '//resolution/text/x'), Res::XML.int(@menu_xml, '//resolution/text/y'), 2)
      box = @box_manager['resolution_left_arrow']
      box.image.draw(box.x, box.y, 2)
      box = @box_manager['resolution_right_arrow']
      box.image.draw(box.x, box.y, 2)
      # Fullscreen changer
      @options_font.draw(Res::XML.text(@menu_xml, '//fullscreen/title/text'), Res::XML.int(@menu_xml, '//fullscreen/title/x'), Res::XML.int(@menu_xml, '//fullscreen/title/y'), 2)
      @options_font.draw(Res::Vars['fullscreen'] ? 'yes' : 'no', Res::XML.int(@menu_xml, '//fullscreen/text/x'), Res::XML.int(@menu_xml, '//fullscreen/text/y'), 2)
      box = @box_manager['fullscreen_left_arrow']
      box.image.draw(box.x, box.y, 2)
      box = @box_manager['fullscreen_right_arrow']
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
              when 'resolution_left_arrow'
                #Decrement one resolution
                Res::Vars['resolution'] = @resolutions[(get_resolution_index() - 1) % @resolutions.count()]
                update_resolution_index()
              when 'resolution_right_arrow'
                #Increment one resolution
                Res::Vars['resolution'] = @resolutions[(get_resolution_index() + 1) % @resolutions.count()]
                update_resolution_index()
              when 'fullscreen_left_arrow'
                #Switch fullscreen
                Res::Vars['fullscreen'] = ! Res::Vars['fullscreen']
              when 'fullscreen_right_arrow'
                #Switch fullscreen
                Res::Vars['fullscreen'] = ! Res::Vars['fullscreen']
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

