#!/usr/bin/env ruby
#engine.rb


class ControllerObject
  def initialize()
    @event_queue = Queue.new()
  end
  
  def update() end
  
  def draw() end
  
  def button_down(id) end
  
  def push_event(symbol, *args)
    @event_queue.push(proc { |receiver| receiver.send(symbol, *args) })
  end
  
  def dispatch_events_to(receiver)
    @event_queue.size().times() do
      @event_queue.pop().call(receiver)
    end
  end
end


class Controller
  def initialize(window)
    @window = window
    @phase = 0
    @menu = Menu.new(window)
    @world = World.new(window)
    @battle = Battle.new(window)
  end
  
  def current_objects()
    case @phase
      when 0
        return [@menu]
      when 1
        return [@world]
      when 2
        return [@battle]
    end
  end
  
  def update()
    current_objects().each() do |object|
      object.update()
      object.dispatch_events_to(self)
    end
  end
  
  def draw()
    current_objects().each() do |object|
      object.draw()
    end
  end
  
  def button_down(id)
    current_objects().each() do |object|
      object.button_down(id)
    end
  end
  
  # Events
  def change_phase(new_phase)
    @phase = new_phase
  end
  
  def set_battle(entity)
    case entity.class().to_s()
      when 'Player'
        @battle.set_player(entity)
      when 'Enemy'
        @battle.set_enemy(entity)
    end
  end
end


module Res # Resource manager (Short name because it gets used a TON)
  def self.initialize(window, variables_filename)
    self::Font.initialize(window)
    self::Vars.load(variables_filename)
  end
  
  module Vars
    @@variable_hash = {}
    @@filename = ''
    def self.load(filename)
      @@filename = filename
      File.open(filename, 'r') do |file|
        @@variable_hash = YAML::load(file.read())
      end
    end
    
    def self.save(filename=@@filename)
      File.open(filename, 'w+') do |file|
        file.print(@@variable_hash.to_yaml())
      end
    end
    
    def self.defaults()
      @@variable_hash = {'volume' => 50, 'resolution' => [1280, 720], 'fullscreen' => false}
    end
    
    def self.[](var_name)
      return @@variable_hash[var_name]
    end
    
    def self.[]=(var_name, variable)
      @@variable_hash[var_name] = variable
    end
  end
  
  module YML
    @@yaml_hash = {}
    def self.[](filename)
      if not @@yaml_hash[filename] then
        File.open(filename, 'r') do |file|
          @@yaml_hash[filename] = YAML::load(file.read())
        end
      end
      return @@yaml_hash[filename]
    end
  end
  
  module Font
    @@font_hash = {}
    @@window = nil
    def self.initialize(window)
      @@window = window
    end
    
    def self.[](font, size)
      if not @@font_hash["#{font},#{size}"] then
        @@font_hash["#{font},#{size}"] = Gosu::Font.new(@@window, font, size)
      end
      return @@font_hash["#{font},#{size}"]
    end
  end
end


class GameWindow < Gosu::Window
  attr_reader :relative_mouse_x, :relative_mouse_y
  
  def initialize(params = {})
    super(params[:window_width], params[:window_height], params[:fullscreen])
    self.caption = params[:caption]
    Gosu::enable_undocumented_retrofication() # Disable bilinear filtering
    Media::initialize(self, '../content/images', '../content/sounds', '../content/tilesets')
    Alphabet::initialize(self)
    WindowSettings::initialize(self, params[:window_width], params[:window_height], params[:width], params[:height])
    Res.initialize(self, '../config.yml')
    @relative_mouse_x = 0
    @relative_mouse_y = 0
    @window_width = params[:window_width]
    @window_height = params[:window_height]
    @controller = Controller.new(self)
    @show_cursor = params[:show_cursor] == nil ? true : params[:show_cursor]
    @show_fps = params[:show_fps] == nil ? false : params[:show_fps]
  end # End GameWindow Initialize
  
  def update()
    @relative_mouse_x = WindowSettings.get_relative_x(mouse_x)
    @relative_mouse_y = WindowSettings.get_relative_y(mouse_y)
    @controller.update()
  end # End GameWindow Update
  
  def draw()
    WindowSettings::formatted_draw() do
      if @show_fps then
        Alphabet::draw_text(Gosu::fps.to_s(), @window_width - 36, 0, 10, 3)
      end
      @controller.draw()
    end
  end # End GameWindow Draw
  
  def button_down(id)
    @controller.button_down(id)
  end
  
  def needs_cursor?()
    return @show_cursor
  end
end # End GameWindow class

