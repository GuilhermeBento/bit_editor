# frozen_string_literal: true
module BitmapErrors
  # Make sure it is a number
  class NumericRequired < StandardError; end
  # Invalid bounds
  class InvalidBounds < StandardError
    def initialize(x, y, max_x, max_y)
      @x_val = x
      @y_val = y
      @max_x = max_x
      @max_y = max_y
    end

    def message
      '(x,y) must be positive and inside the width and height of '\
      "(#{@max_x},#{@max_y}). received (#{@x_val},#{@y_val})"
    end
  end
  # Invalid start
  class InvalidStart < StandardError
    def initialize(start_value, end_value, variable)
      @start_value = start_value
      @end_value = end_value
      @variable = variable
    end

    def message
      "start #{@variable} (#{@start_value}) must be smaller or equal to end "\
      "#{@variable} (#{@end_value})"
    end
  end
  # No @matrix
  class ImageNotInitialized < StandardError; end
end
