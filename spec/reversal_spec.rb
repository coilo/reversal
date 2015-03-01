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
end