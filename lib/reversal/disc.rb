# coding: utf-8
#
module Reversal
  # Reversal Disc class 
  class Disc
    attr_accessor :reverse
    attr_reader   :raw
    
    def initialize(color)
      @raw = color
    end

    # Raw value of disc: 
    raw_disc = { white: :white, empty: :empty, black: :black }
    
    raw_disc.each do |key, color|
      instance_variable_set("@#{color}", Disc.new(raw_disc[key]))

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
