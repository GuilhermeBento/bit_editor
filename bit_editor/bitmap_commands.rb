# frozen_string_literal: true
# Commands to be used in editor
class BitmapCommands
  def init_matrix(input)
    width = input[1].to_i
    height = input[2].to_i
    @matrix = BitmapMatrix.new(width, height)
    @viewer = BitmapViewer.new(@matrix)
  end

  def color_bit(input)
    verify_matrix
    x = input[1].to_i
    y = input[2].to_i
    color = input[3]
    @matrix.color_range!(x, y, x, y, color)
  end

  def color_vertical(input)
    verify_matrix
    x = input[1].to_i
    y = input[2].to_i
    y2 = input[3].to_i
    color = input[4]
    @matrix.color_range!(x, y, x, y2, color)
  end

  def color_horizontal(input)
    verify_matrix
    x = input[1].to_i
    x2 = input[2].to_i
    y = input[3].to_i
    color = input[4]
    @matrix.color_range!(x, y, x2, y, color)
  end

  def color_fill_region(input)
    verify_matrix
    x = input[1].to_i
    y = input[2].to_i
    color = input[3]
    @matrix.color_region!(x, y, color)
  end

  def verify_matrix
    raise BitmapErrors::ImageNotInitialized unless @matrix
  end

  def exit_console
    puts 'Have a nice day!'
    @running = false
  end
  # TODO add F feature
  def show_help
    puts '* I M N - Create a new M x N image with all pixels coloured white (O).
* C - Clears the table, setting all pixels to white (O).
* L X Y C - Colours the pixel (X,Y) with colour C.
* V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
* H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive)
* F X Y C - Fill the region R with the colour C. R is defined as: Pixel (X,Y) belongs to R. Any
other pixel which is the same colour as (X,Y) and shares a common side with any pixel in R also belongs to this region.
* S - Show the contents of the current image
* ? - Displays help text
* X - Terminate the session'
  end
end
