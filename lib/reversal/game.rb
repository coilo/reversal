# coding: utf-8

require 'reversal/board'

module Reversal
  #
  class Game
    #
    def initialize(black: nil, white: nil)
      @command = Array.new(60)
      @client  = { black: black, white: white }

      # Game loop.
      @game = Fiber.new do
        @board = Board.new
        runloop
      end
    end

    #
    def next
      @game.resume
    end

    private

    #
    def runloop
      loop do
        client = @client[@board.order.raw]

        #
        position = client.turn
        @command << @board
        @board = @board.mount(*position)
        @order = @board.order.raw

        Fiber.yield(@board.clone)
      end
    end
  end
end
