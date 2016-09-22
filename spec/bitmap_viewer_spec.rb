# frozen_string_literal: true
require_relative '../bit_editor/bitmap_viewer'
require_relative '../bit_editor/bitmap_matrix'
require_relative '../bit_editor/bitmap_errors'

describe('BitmapViewer') do
  before do
    @matrix_double = double(BitmapMatrix, width: 2, height: 3)
    @viewer = BitmapViewer.new(@matrix_double)
  end

  describe '#present_as_string' do
    before do
      expect(@matrix_double).to receive(:position_at).with(1, 1).and_return('X')
      expect(@matrix_double).to receive(:position_at).with(2, 1).and_return('X')
      expect(@matrix_double).to receive(:position_at).with(1, 2).and_return('Y')
      expect(@matrix_double).to receive(:position_at).with(2, 2).and_return('Y')
      expect(@matrix_double).to receive(:position_at).with(1, 3).and_return('Z')
      expect(@matrix_double).to receive(:position_at).with(2, 3).and_return('W')
    end

    it 'returns a string with a line for each row' do
      expect(@viewer.present_as_string).to eql "XX\nYY\nZW\n"
    end
  end
end
