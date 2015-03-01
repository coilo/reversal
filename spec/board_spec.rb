require 'spec_helper'

describe Reversal::Board do
  before {
    @board = Reversal::Board.new
  }
  
  it "Initialize" do
    
    # Board#size == Reversal::BOARD_SIZE
    expect(@board.size).to eq(Reversal::BOARD_SIZE)
    # Board#order == Reversal::Disc.black
    expect(@board.order).to eq(Reversal::Disc.black)
    
    # Board[3,3][4,4] == Reversal::Disc.black
    # Board[3,4][4,3] == Reversal::Disc.white
    expect(@board[3,3]).to eq(Reversal::Disc.black)
    expect(@board[4,4]).to eq(Reversal::Disc.black)
    expect(@board[3,4]).to eq(Reversal::Disc.white)
    expect(@board[4,3]).to eq(Reversal::Disc.white)
    
    expect(@board.is_black?(3,3)).to be_truthy
    expect(@board.is_black?(4,4)).to be_truthy
    expect(@board.is_white?(3,4)).to be_truthy
    expect(@board.is_white?(4,3)).to be_truthy
    expect(@board.is_empty?(2,1)).to be_truthy
    expect(@board.is_empty?(1,2)).to be_truthy
  end
  
  it "mount" do
    next_board = @board.mount(4,2)
    expect(next_board[3,3]).to eq(Reversal::Disc.black)
    expect(next_board[3,4]).to eq(Reversal::Disc.white)
    expect(next_board[4,2]).to eq(Reversal::Disc.black)
    expect(next_board[4,3]).to eq(Reversal::Disc.black)
    expect(next_board[4,4]).to eq(Reversal::Disc.black)
  end
end