require 'reversal/disc'

#
module Reversal
  ##
  BOARD_SIZE = 8

  #
  class Board
    attr_accessor :order

    @offsets = []
    Offset = Struct.new(:down, :right)

    [-1, 0, 1].repeated_permutation(2) do |down, right|
      next if down == 0 && right == 0
      @offsets << Offset.new(down, right)
    end

    ##
    def initialize(board_size = BOARD_SIZE, order = Reversal::Disc.black)
      @board_size  = board_size
      @board_range = 0..@board_size - 1
      @order = order

      @board = Array.new(@board_size**2).map.with_index do |_item, index|
        disc_set(index)
      end
    end

    ##
    def mobility_iterator!(row, col, down: down, right: right)
      move = 0
      loop do
        row, col = (row + down), (col + right)
        break unless include?(row, col)

        move += 1
        disc = yield get_disc(row, col), move
        set_disc(row, col, disc)
      end
    end

    ##
    def mount(row, col)
      return nil unless include?(row, col)

      ##
      after = before = self
      Board.offsets.each do |offset|
        temp = before.dup
        temp.mobility_iterator!(row, col, down: offset.down, right: offset.right) do |item, move|
          case item
          when Reversal::Disc.empty
            break
          when @order
            after = temp if move > 1
            break
          end
          item.reverse
        end
      end

      return nil unless after != before

      ##
      after[row, col], after.order = @order, @order.reverse
      after
    end

    def candidates
      candidates = {}
      64.times do |index|
        row, col = coordinate(index)
        candidates[[row, col]] = mount(row, col)
      end
      candidates
    end

    ##
    def [](row, col)
      get_disc(row, col)
    end

    ##
    def []=(row, col, value)
      set_disc(row, col, value)
    end

    private

    ##
    def disc_set(index)
      center = (@board_size / 2).ceil
      range  = center - 1..center

      row, col = coordinate(index)
      if range.include?(row) && range.include?(col)
        row == col ? Reversal::Disc.black : Reversal::Disc.white
      else
        Reversal::Disc.empty
      end
    end

    ##
    def coordinate(index)
      [index / @board_size, index % @board_size]
    end

    ##
    def include?(row, col)
      @board_range.include?(row) && @board_range.include?(col)
    end

    #
    def get_disc(row, col)
      @board[row * @board_size + col]
    end

    def set_disc(row, col, value)
      @board[row + @board_size + col] = value
    end

    class << self
      attr_reader :offsets
    end
  end
end
