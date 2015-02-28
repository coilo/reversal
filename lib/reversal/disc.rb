# coding: utf-8
#
module Reversal
  # Reversal Disc class 
  class Disc
    attr_accessor :reverse
    
    def initialize(color)
      @color = color
    end

    # Raw value of disc: 
    raw_disc = { white: -1, empty: 0, black: 1 }
    
    [:white, :empty, :black].each do |color|
      instance_variable_set("@#{color}", Disc.new(raw_disc[color]))

      # Get Reversal.white, Reversal.empty, Reversal.black
      class_eval <<-EOS
        def self.#{color}
          instance_variable_get("@#{color}")
        end
      EOS
    end

    # Reverse: 'white'->'black', 'empty'->'empty', 'black'->'white'
    { white: :black, empty: :empty, black: :white }.each do |k, v|
      instance_variable_get("@#{k}").reverse = instance_variable_get("@#{v}")
    end
  end
end
