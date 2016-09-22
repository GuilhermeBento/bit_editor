# frozen_string_literal: true
require 'spec_helper'
require_relative '../bit_editor/bitmap_matrix'
require_relative '../bit_editor/bitmap_errors'

describe 'bitmap_matrix' do
  describe '#initialize' do
    it 'throws if input is too large' do
      error = '(x,y) must be positive and inside the width and height of (250,250).'\
      ' received (250,251)'
      expect { BitmapMatrix.new(250, 251) }.to raise_error(error)
    end

    it 'throws if input is too small' do
      expect { BitmapMatrix.new(-1, 1) }.to raise_error(BitmapErrors::InvalidBounds)
    end
  end
  describe '#bit_at' do
    before do
      @matrix = BitmapMatrix.new(5, 6)
    end

    it 'throws if input is out of range' do
      expect { @matrix.position_at(5, 7) }.to raise_error(BitmapErrors::InvalidBounds)
    end

    it 'is initially all Os' do
      expect_default
    end
  end

  describe '#color_range!' do
    before do
      @matrix = BitmapMatrix.new(5, 6)
    end

    it 'throws if start coordinates are out of range' do
      msg = '(x,y) must be positive and inside the width and height of (5,6). received (5,7)'
      expect { @matrix.color_range!(5, 7, 5, 7, 'B') }.to raise_error(msg)
    end

    it 'throws if end coordinates are out of range' do
      msg = '(x,y) must be positive and inside the width and height of (5,6). received (6,5)'
      expect { @matrix.color_range!(1, 3, 6, 5, 'B') }.to raise_error(msg)
    end

    it 'throws if x end coordinates are smaller than start x coordinates' do
      expect { @matrix.color_range!(2, 3, 1, 4, 'B') }.to raise_error(BitmapErrors::InvalidStart)
    end

    it 'throws if y end coordinates are smaller than start y coordinates' do
      expect { @matrix.color_range!(2, 3, 4, 1, 'B') }.to raise_error(BitmapErrors::InvalidStart)
    end

    it 'colors a single cell' do
      @matrix.color_range!(2, 3, 2, 3, 'test')
      expect(@matrix.position_at(2, 3)).to eql 'test'
      expect_default(2, 3, 2, 3)
    end

    it 'colors a vertical line' do
      @matrix.color_range!(1, 2, 3, 2, 'test')
      expect(@matrix.position_at(1, 2)).to eql 'test'
      expect(@matrix.position_at(2, 2)).to eql 'test'
      expect(@matrix.position_at(3, 2)).to eql 'test'
      expect_default(1, 2, 3, 2)
    end

    it 'colors a horizontal line' do
      @matrix.color_range!(1, 2, 1, 3, 'test')
      expect(@matrix.position_at(1, 2)).to eql 'test'
      expect(@matrix.position_at(1, 3)).to eql 'test'
      expect_default(1, 2, 1, 3)
    end

    it 'colors an arbitrary rectangle' do
      @matrix.color_range!(1, 2, 2, 4, 'test')
      expect(@matrix.position_at(1, 2)).to eql 'test'
      expect(@matrix.position_at(2, 2)).to eql 'test'
      expect(@matrix.position_at(1, 3)).to eql 'test'
      expect(@matrix.position_at(1, 4)).to eql 'test'
      expect(@matrix.position_at(2, 3)).to eql 'test'
      expect(@matrix.position_at(2, 4)).to eql 'test'

      expect_default(1, 2, 2, 4)
    end
  end

  describe '#color_region!' do
    before do
      @matrix = BitmapMatrix.new(5, 6)
    end

    it 'colors a point and adjacent cells' do
      @matrix.color_range!(2, 3, 2, 3, 'test')
      @matrix.color_region!(2, 3, 'test_2')
      expect(@matrix.position_at(2, 3)).to eql 'test_2'
      expect(@matrix.position_at(1, 3)).to eql 'test_2'
      expect(@matrix.position_at(2, 2)).to eql 'test_2'
      expect(@matrix.position_at(2, 4)).to eql 'test_2'
      expect(@matrix.position_at(3, 3)).to eql 'test_2'
    end

    it 'keeps non adjacent points color' do
      @matrix.color_range!(2, 3, 2, 3, 'test')
      @matrix.color_region!(2, 3, 'test_2')
      expect(@matrix.position_at(1, 2)).to eql 'O'
      expect(@matrix.position_at(3, 4)).to eql 'O'
    end
  end

  def expect_default(except_start_x = -1, except_start_y = -1, except_end_x = -1, except_end_y = -1)
    (1..5).each do |x|
      (1..6).each do |y|
        next if  x.between?(except_start_x, except_end_x) &&
                 y.between?(except_start_y, except_end_y)
        expect(@matrix.position_at(x, y)).to eql 'O'
      end
    end
  end
end
