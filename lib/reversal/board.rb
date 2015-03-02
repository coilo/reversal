# coding: utf-8

require 'reversal/disc'

module Reversal
  ##
  BOARD_SIZE = 8

  # Reversal board class
  class Board
    attr_accessor :order
    attr_reader   :size

    @offsets = []
    Offset = Struct.new(:down, :right)

    # @offsets(:down, :right) =
    # [0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,1],[-1,-1]
    [-1, 0, 1].repeated_permutation(2) do |down, right|
      next if down == 0 && right == 0
      @offsets << Offset.new(down, right)
    end
    
    ##
    def initialize(board_size = BOARD_SIZE, order = Reversal::Disc.black)
      @size  = board_size
      @range = 0..@size - 1
      @order = order

      # Prepare for the board to use in the game.
      @board = Array.new(@size**2).map.with_index do |_item, index|
        prepare(index)
      end
    end
    
    def clone
      instance = Reversal::Board.new(8, @order.clone)
      instance.load(@board.clone)
      instance
    end

    ##
    def mobility_iterator!(row, col, down: down, right: right)
      move = 0
      loop do
        
        # End if outside the range of the board.
        next_r, next_c = (row + down), (col + right)
        break unless include?(next_r, next_c)

        # Return the disc of the position(row+down, col+right).
        move += 1
        disc = yield get_disc(next_r, next_c), move
        
        # Set the reverse disc in the position(row+down, col+right).
        set_disc(next_r, next_c, disc)
      end
    end

    ##
    def mount(row, col)
      return nil unless include?(row, col)
      return nil unless is_empty?(row, col)

      ##
      after = before = self
      Board.offsets.each do |offset|
        temp = before.clone
        
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

    # List up
    def candidates
      candidates = {}
      64.times do |index|
        row, col = coordinate(index)
        candidates[[row, col]] = mount(row, col)
      end
      candidates
    end

    # Get the disc instance in position(row, col)
    def [](row, col)
      get_disc(row, col)
    end

    # Set the disc instance in position(row, col)
    def []=(row, col, value)
      set_disc(row, col, value)
    end

    #
    [:white, :empty, :black].each do |color|
      class_eval <<-EOS
        def is_#{color}?(row, col)
          self[row, col] == Reversal::Disc.#{color}
       end
      EOS
    end
  
    protected

    ##
    def load(board)
      @board = board if board.kind_of?(Array)
    end

    private

    ##
    def prepare(index)
      center = (@size / 2).ceil
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
      [index / @size, index % @size]
    end

    # Query: included within the range
    def include?(row, col)
      @range.include?(row) && @range.include?(col)
    end

    # Get the disc instance in position(row, col)
    def get_disc(row, col)
      @board[row * @size + col]
    end

    # Set the disc instance in position(row, col)
    def set_disc(row, col, value)
      @board[row * @size + col] = value
    end

    class << self
      attr_reader :offsets
    end
  end
end
