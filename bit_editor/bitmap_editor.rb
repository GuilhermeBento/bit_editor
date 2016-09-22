# frozen_string_literal: true
require_relative './bitmap_matrix'
require_relative './bitmap_viewer'
require_relative './bitmap_commands'
require_relative './bitmap_errors'
# require 'pry'
# Main class
class BitmapEditor < BitmapCommands
  def run
    @running = true
    puts 'type ? for help'
    while @running
      print '=> '
      begin
        command_builder(gets.chomp.split)
      rescue => e
        puts e.message
      end
    end
  end

  private

  def command_builder(user_input)
    case user_input[0]
    when 'I', 'i'
      init_matrix(user_input)
    when 'C', 'c'
      verify_matrix
      @matrix.color_range!(1, 1, @matrix.width, @matrix.height, '0')
    when 'L', 'l'
      color_bit(user_input)
    when 'V', 'v'
      color_vertical(user_input)
    when 'H', 'h'
      color_horizontal(user_input)
    when 'F', 'f'
      color_fill_region(user_input)
    when 'S', 's'
      verify_matrix
      puts @viewer.present_as_string
    when '?'
      show_help
    when 'X', 'x'
      exit_console
    else
      puts 'Unrecognised command'
    end
  end
end
