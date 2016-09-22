# frozen_string_literal: true
# Responsible for the console output
class BitmapViewer
  def initialize(bitmap_image)
    @matrix = bitmap_image
  end

  def present_as_string
    str = ''
    (1..@matrix.height).each do |i|
      (1..@matrix.width).each do |j|
        str += @matrix.position_at(j, i)
      end
      str += "\n"
    end
    str
  end
end
