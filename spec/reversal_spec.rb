require 'spec_helper'

describe Reversal do
  it 'version' do
    expect(Reversal::VERSION).to eq('0.0.1')
  end

  it 'disc' do
    expect(Reversal::Disc.white.raw).to eq(:white)
    expect(Reversal::Disc.empty.raw).to eq(:empty)
    expect(Reversal::Disc.black.raw).to eq(:black)

    expect(Reversal::Disc.black.reverse).to eq(Reversal::Disc.white)
    expect(Reversal::Disc.empty.reverse).to eq(Reversal::Disc.empty)
    expect(Reversal::Disc.white.reverse).to eq(Reversal::Disc.black)
  end

  it 'game' do
    client = Reversal::Client.new
    def client.prepare
      @game = Fiber.new do
        [[4,2],[5,2]].each do |location|
          Fiber.yield(location)
        end
      end
    end
    def client.turn
      @game.resume
    end
    client.prepare

    game = Reversal::Game.new(black: client, white: client)
    board = nil
    2.times do
      board = game.next
    end

    [[3,3],[4,2],[4,4]].each do |row, col|
      expect(board[row, col]).to eq(Reversal::Disc.black)
    end
    [[3,4],[4,3],[5,2]].each do |row, col|
      expect(board[row, col]).to eq(Reversal::Disc.white)
    end
  end
end
