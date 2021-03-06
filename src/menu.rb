#!/usr/bin/env ruby
#menu.rb


class Menu < ControllerObject
  def initialize(window)
    super()
    @window = window
    @menu_yml = Res::YML['../interface/menu.yml']
    @options_font = Res::Font[@menu_yml['options']['font']['name'], @menu_yml['options']['font']['size']]
    @box_manager = BoundingBoxManager.new()
    register_buttons()
    @current_boxes_under_mouse = Array.new()
    @phase = 0 # 0 = Main menu, 1 = Load game, 2 = Options 
    @resolutions = get_resolution_list()
    update_resolution_index()
    # Ship animation
    @ship_manager = BoundingBoxManager.new()
    @num_ships = 10
    @num_ships.times() do |n|
      @ship_manager.add_box(Ship_Animation.new(), n)
    end
    # Easter egg below
    @list = [Gosu::Button::KbUp, Gosu::Button::KbUp, Gosu::Button::KbDown, Gosu::Button::KbDown,
             Gosu::Button::KbLeft, Gosu::Button::KbRight, Gosu::Button::KbLeft, Gosu::Button::KbRight,
             Gosu::Button::KbB, Gosu::Button::KbA, Gosu::Button::KbReturn]
    @list_index = 0
    @egg_music = Media::get_sound('songs/click.ogg')
    @list_tick = 0
    @egg_overlay_color = Gosu::Color.argb(100, rand(255), rand(255), rand(255))
    # Recording mode true = recording, false = playing
    @recording_mode = false
    if @recording_mode then
      @showtime_hash = {}
    else
      File.open('hash.yml', 'r') do |file|
        @showtime_hash = YAML::load(file.read())
      end
    end
  end
  
  def update()
    @current_boxes_under_mouse = @box_manager.hit_test_boxes(@window.relative_mouse_x, @window.relative_mouse_y)
    if @current_boxes_under_mouse.include?('volume') and @window.button_down?(Gosu::Button::MsLeft) then
      # Modify volume
      Res::Vars['volume'] = ((((@window.relative_mouse_x - @menu_yml['options']['volume']['slider']['x']) / Media::get_image(@menu_yml['options']['volume']['slider']['background']).width()) * 100) / 5.0).round() * 5
    end
    # Ship animation
    @num_ships.times() do |n|
      @ship_manager[n].update()
    end
  end
  
  def get_resolution_list()
    result = Array.new()
    @menu_yml['resolutions'].each() do |resolution|
      result << [resolution['width'], resolution['height']]
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
    @box_manager.register_image(@menu_yml['main']['new_game']['x'],
                                @menu_yml['main']['new_game']['y'],
                                Media::get_image(@menu_yml['main']['new_game']['image']),
                                'new_game')
    @box_manager['new_game'].extra = Media::get_image(@menu_yml['main']['new_game']['image_hover'])
    # Load game button
    @box_manager.register_image(@menu_yml['main']['load_game']['x'],
                                @menu_yml['main']['load_game']['y'],
                                Media::get_image(@menu_yml['main']['load_game']['image']),
                                'load_game')
    @box_manager['load_game'].extra = Media::get_image(@menu_yml['main']['load_game']['image_hover'])
    # Options button
    @box_manager.register_image(@menu_yml['main']['options']['x'],
                                @menu_yml['main']['options']['y'],
                                Media::get_image(@menu_yml['main']['options']['image']),
                                'options')
    @box_manager['options'].extra = Media::get_image(@menu_yml['main']['options']['image_hover'])
    # Quit button
    @box_manager.register_image(@menu_yml['main']['quit']['x'],
                                @menu_yml['main']['quit']['y'],
                                Media::get_image(@menu_yml['main']['quit']['image']),
                                'quit')
    @box_manager['quit'].extra = Media::get_image(@menu_yml['main']['quit']['image_hover'])
    # Volume slider
    @box_manager.register_image(@menu_yml['options']['volume']['slider']['x'],
                                @menu_yml['options']['volume']['slider']['y'],
                                Media::get_image(@menu_yml['options']['volume']['slider']['background']),
                                'volume')
    # Resolution Left arrow
    @box_manager.register_image(@menu_yml['options']['resolution']['left_arrow']['x'],
                                @menu_yml['options']['resolution']['left_arrow']['y'],
                                Media::get_image(@menu_yml['options']['resolution']['left_arrow']['image']),
                                'resolution_left_arrow')
    # Resolution Right arrow
    @box_manager.register_image(@menu_yml['options']['resolution']['right_arrow']['x'],
                                @menu_yml['options']['resolution']['right_arrow']['y'],
                                Media::get_image(@menu_yml['options']['resolution']['right_arrow']['image']),
                                'resolution_right_arrow')
    # Fullscreen Left arrow
    @box_manager.register_image(@menu_yml['options']['fullscreen']['left_arrow']['x'],
                                @menu_yml['options']['fullscreen']['left_arrow']['y'],
                                Media::get_image(@menu_yml['options']['fullscreen']['left_arrow']['image']),
                                'fullscreen_left_arrow')
    # Fullscreen Right arrow
    @box_manager.register_image(@menu_yml['options']['fullscreen']['right_arrow']['x'],
                                @menu_yml['options']['fullscreen']['right_arrow']['y'],
                                Media::get_image(@menu_yml['options']['fullscreen']['right_arrow']['image']),
                                'fullscreen_right_arrow')
    # Apply button
    @box_manager.register_image(@menu_yml['options']['apply']['x'],
                                @menu_yml['options']['apply']['y'],
                                Media::get_image(@menu_yml['options']['apply']['image']),
                                'apply')
    @box_manager['apply'].extra = Media::get_image(@menu_yml['options']['apply']['image_hover'])
    # Defaults button
    @box_manager.register_image(@menu_yml['options']['defaults']['x'],
                                @menu_yml['options']['defaults']['y'],
                                Media::get_image(@menu_yml['options']['defaults']['image']),
                                'defaults')
    @box_manager['defaults'].extra = Media::get_image(@menu_yml['options']['defaults']['image_hover'])
  end
  
  def draw_box(id, z=2)
    box = @box_manager[id]
    if box.extra and @current_boxes_under_mouse.include?(id) then
      box.extra.draw(box.x, box.y, z)
    else
      box.image.draw(box.x, box.y, z)
    end
  end
  
  def draw()
    Alphabet::draw_text('Copyright 2013 Chase Arnold & James Hammond', 752, 704, 10, 2)
    # Background
    20.times() do |x|
      12.times() do |y|
        Media::get_graphic('64x64/ocean.png')[(Gosu::milliseconds / 75) % Media::get_graphic('64x64/ocean.png').size].draw(x*64, y*64, 1)
      end
    end
    # Ship animation
    @num_ships.times do |n|
      @ship_manager[n].draw(2)
    end
    # Title
    Media::get_image(@menu_yml['title']['image']).draw(@menu_yml['title']['x'], @menu_yml['title']['y'], 3)
    # New game button
    draw_box('new_game')
    # Load game button
    draw_box('load_game')
    # Options button
    draw_box('options')
    # Quit button
    draw_box('quit')
    if @phase == 2 then # Options menu
      # Options background
      Media::get_image(@menu_yml['options']['background']['image']).draw(@menu_yml['options']['background']['x'], @menu_yml['options']['background']['y'], 1)
      # Sound slider
      @options_font.draw(@menu_yml['options']['volume']['text']['text'], @menu_yml['options']['volume']['text']['x'], @menu_yml['options']['volume']['text']['y'], 2)
      draw_box('volume')
      @options_font.draw("#{Res::Vars['volume']}%", @menu_yml['options']['volume']['percentage']['x'], @menu_yml['options']['volume']['percentage']['y'], 2)
      Media::get_image(@menu_yml['options']['volume']['slider']['image']).draw(((Res::Vars['volume'] / 100.0) * Media::get_image(@menu_yml['options']['volume']['slider']['background']).width()) + @menu_yml['options']['volume']['slider']['x'] - (Media::get_image(@menu_yml['options']['volume']['slider']['image']).width() / 2), @menu_yml['options']['volume']['slider']['y'] + (Media::get_image(@menu_yml['options']['volume']['slider']['image']).height() / 2), 3)
      # Apply button
      draw_box('apply', 3)
      # Defaults button
      draw_box('defaults', 3)
      # Resolution changer
      @options_font.draw(@menu_yml['options']['resolution']['title']['text'], @menu_yml['options']['resolution']['title']['x'], @menu_yml['options']['resolution']['title']['y'], 2)
      @options_font.draw("#{@resolutions[@resolution_index][0]}x#{@resolutions[@resolution_index][1]}", @menu_yml['options']['resolution']['text']['x'], @menu_yml['options']['resolution']['text']['y'], 2)
      draw_box('resolution_left_arrow')
      draw_box('resolution_right_arrow')
      # Fullscreen changer
      @options_font.draw(@menu_yml['options']['fullscreen']['title']['text'], @menu_yml['options']['fullscreen']['title']['x'], @menu_yml['options']['fullscreen']['title']['y'], 2)
      @options_font.draw(Res::Vars['fullscreen'] ? 'yes' : 'no', @menu_yml['options']['fullscreen']['text']['x'], @menu_yml['options']['fullscreen']['text']['y'], 2)
      draw_box('fullscreen_left_arrow')
      draw_box('fullscreen_right_arrow')
    end
    #Easter Egg -- Up up down down left right left right b a enter -on the main menu
    if @list_tick > 0 then
      @list_tick += 1
      draw_square(@window, 639, 0, 2, 2, -300 + (@list_tick < 460 ? @list_tick : 460), 0xff000000)
      Media::get_image('menu/ball.png').draw(490, -300 + (@list_tick < 460 ? @list_tick : 460), 11)
      
      if not @recording_mode then
        if @showtime_hash[-@list_tick] then
          Media::get_image('menu/spotlight.png').draw(0, 0, 10, 3, 3)
        end
        if @showtime_hash[@list_tick] then
          Media::get_image('menu/spotlight.png').draw(1280, 0, 10, -3, 3)
        end
      end
      if @list_tick > 516 then
        every(28) do
          @egg_overlay_color = Gosu::Color.argb(100, rand(255), rand(255), rand(255))
        end
        draw_square(@window, 0, 0, 10, 1280, 720, @egg_overlay_color)
      end
    end
  end
  
  def button_press_over_id(id, button_id)
    case button_id
      when Gosu::Button::MsLeft
        case @phase
          when 0 # Main menu
            case id
              when 'new_game'
                #Switch to the world phase
                push_event(:change_phase, 1)
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
    
    if id == @list[@list_index] then
      if @list_index == (@list.count() - 1) then
        @num_ships.times() do |n|
          @ship_manager[n].go_fast()
        end
        @egg_music.play()
        @list_tick = 1
      else
        @list_index += 1
      end
    else
      @list_index = 0
    end
    
    if @recording_mode then
      if id == Gosu::KbLeft then
        if @list_tick > 0 then
          8.times() do |i|
            @showtime_hash[-1 * (@list_tick + i)] = true
          end
        end
      end
      if id == Gosu::KbRight then
        if @list_tick > 0 then
          8.times() do |i|
            @showtime_hash[@list_tick + i] = true
          end
        end
      end
      if id == Gosu::KbSpace then
        if @list_tick > 0 then
          puts "saving hash"
          File.open('hash.yml', 'w+') do |file|
            file.print(@showtime_hash.to_yaml())
          end
        end
      end
    end
  end
end


class Ship_Animation < BoundingBox
  def initialize()
    @x = rand(1280)
    @y = rand(720)
    @image = Media::get_image('ship.png')
    @width = @image.width
    @height = @image.height
    @extra = nil
    @angle = rand(360)
    @target = [rand(1280), rand(720)]
    @speed = 1
    @rot_speed = 1
  end
  
  def go_fast()
    # easter egg
    @speed = 10
    @rot_speed = 8
  end
  
  def update()
    # Rotate to the new target
    @angle = angle_smoother(@angle, Gosu::angle(@x, @y, *@target), @rot_speed)
    # Move to target
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    if Gosu::distance(@x, @y, *@target) < 50 then
      @target = [rand(1280), rand(720)]
    end
  end
  
  def draw(z)
    @image.draw_rot(@x, @y, z, @angle)
  end
end

