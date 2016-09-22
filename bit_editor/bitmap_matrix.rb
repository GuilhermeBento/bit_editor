# frozen_string_literal: true
# Creates the matrix
class BitmapMatrix
  DEFAULT_COLOR = 'O'

  attr_reader :width, :height

  def initialize(width, height)
    verify_bounds(width, height, 250, 250)
    @width = width
    @height = height
    @matrix = Array.new(@width) { Array.new(@height, DEFAULT_COLOR) }
  end

  def position_at(x, y)
    verify_bounds(x, y)
    @matrix[x - 1][y - 1] || DEFAULT_COLOR
  end

  def color_range!(start_x, start_y, end_x, end_y, color)
    verify_bounds(start_x, start_y)
    verify_bounds(end_x, end_y)
    raise BitmapErrors::InvalidStart.new(start_x, end_x, 'x') if start_x > end_x
    raise BitmapErrors::InvalidStart.new(start_y, end_y, 'y') if start_y > end_y
    fill_matrix(start_x, end_x, start_y, end_y, color)
    self
  end

  def color_region!(x, y, color)
    verify_bounds(x, y)
    current_region = fill_matrix_area(x, y, color).flatten!(1).compact
    current_region.each do |region|
      fill_bounding_box(region[0], region[1], color)
    end
  end

  private

  def fill_matrix(start_x, end_x, start_y, end_y, color)
    ((start_x - 1)..(end_x - 1)).each do |i|
      ((start_y - 1)..(end_y - 1)).each do |j|
        @matrix[i][j] = color
      end
    end
  end

  # return modified values to improve bounding search time
  def fill_matrix_area(x, y, color)
    target_color = position_at(x, y)
    (0..(@width - 1)).map do |i|
      (0..(@height - 1)).map do |j|
        next unless @matrix[i][j] == target_color
        @matrix[i][j] = color
        [i, j]
      end
    end
  end

  # Check bounds
  def fill_bounding_box(x, y, color)
    # directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    directions = [[-1, 0], [0, -1], [0, 1], [1, 0]]
    directions.each do |direction|
      next if invalid_direction?(x, y, direction)
      next if @matrix[x + direction[0]][y + direction[1]] == color
      @matrix[x + direction[0]][y + direction[1]] = color
    end
  end

  def invalid_direction?(x, y, direction)
    return true if x + direction[0] >= @width || (x + direction[0]).negative?
    y + direction[1] >= @height || (y + direction[1]).negative?
  end

  def verify_bounds(x, y, max_x = @width, max_y = @height)
    return unless x > max_x || y > max_y || x < 1 || y < 1
    raise BitmapErrors::InvalidBounds.new(x, y, max_x, max_y)
  end

  def validate_inputs(*inputs)
    raise BitmapErrors::NumericRequired unless inputs.all? { |input| input.is_a? Numeric }
  end
end
