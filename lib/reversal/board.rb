require 'reversal/disc'

#
module Reversal
  ##
  BOARD_SIZE = 8

  #
  class Board
    @offset = []
    Offset = Struct.new(:down, :right)

    [-1, 0, 1].repeated_permutation(2) do |down, right|
      next if down == 0 && right == 0
      @offset << Offset.new(down, right)
    end

    ##
    def initialize(board_size = BOARD_SIZE, order = Reversal::Disc.black)
      @board_size  = board_size
      @order = order

      @board = Array.new(@board_size**2).map.with_index do |_item, index|
        disc_set(index)
      end
    end

    private

    #
    def disc_set(index)
      center = (@board_size / 2).ceil
      range  = center - 1..center

      row, col = index / @board_size, index % @board_size
      if range.include?(row) && range.include?(col)
        row == col ? Reversal::Disc.black : Reversal::Disc.white
      else
        Reversal::Disc.empty
      end
    end
  end
end
