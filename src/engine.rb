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
  end
  
  def current_objects()
    case @phase
      when 0
        return [@menu]
      #when 1
        #return [@gui, @dungeon_controller]
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
end


module XML_Manager
  @@xml_hash = {}
  def self.[](filename)
    if not @@xml_hash[filename] then
      @@xml_hash[filename] = XmlSimple.xml_in(filename, { 'KeyAttr' => 'name', 'ForceArray' => false })
    end
    return @@xml_hash[filename]
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
    @relative_mouse_x = 0
    @relative_mouse_y = 0
    @controller = Controller.new(self)
    @show_cursor = params[:show_cursor] == nil ? true : params[:show_cursor]
  end # End GameWindow Initialize
  
  def update()
    @relative_mouse_x = WindowSettings.get_relative_x(mouse_x)
    @relative_mouse_y = WindowSettings.get_relative_y(mouse_y)
    @controller.update()
  end # End GameWindow Update
  
  def draw()
    WindowSettings::formatted_draw() do
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

