

def draw_square(window, x, y, z, width, height, color = 0xffffffff)
  window.draw_quad(x, y, color, x + width, y, color, x, y + height, color, x + width, y + height, color, z)
end


# Adds the ability to draw text including line breaks
module Gosu
  class Font
    def draw_with_linebreaks(text, x, y, z, factor_x = 1, factor_y = 1, color = 0xffffffff, mode = :default, y_padding=0)
      text.split("\n").each_with_index() do |line, i|
        self.draw(line, x, y+(i*(self.height+y_padding)), z, factor_x, factor_y, color, mode)
      end
    end
  end
end


# Requires lib_misc.rb
class BoundingBoxManager
  def register_image(x, y, gosu_image, id)
    @bounding_box_hash[id] = BoundingBox.new(x, y, gosu_image.width(), gosu_image.height(), gosu_image)
  end
end


module WindowSettings
  @@window = nil
  @@scale_x = 0
  @@scale_y = 0
  @@default_width = 0
  @@default_height = 0
  
  def self.get_scale_x()
    return @@scale_x
  end
  
  def self.get_scale_y()
    return @@scale_y
  end
  
  def self.get_relative_x(x)
    return x / @@scale_x
  end
  
  def self.get_relative_y(y)
    return y / @@scale_y
  end
  
  def self.initialize(window, width, height, default_width, default_height)
    @@window = window
    @@default_width = default_width
    @@default_height = default_height
    @@scale_x = width / default_width.to_f()
    @@scale_y = height / default_height.to_f()
  end
  
  def self.formatted_draw(&block)
    @@window.scale(@@scale_x, @@scale_y) do
      @@window.clip_to(0, 0, @@default_width, @@default_height) do
        block.call()
      end
    end
  end
end

