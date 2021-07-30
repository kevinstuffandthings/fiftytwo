# frozen_string_literal: true

module FiftyTwo
  class Suit
    class Color
      attr_reader :name, :rgb

      def initialize(name, rgb)
        @name = name
        @rgb = rgb
      end

      ALL = [
        RED = new("red", "ff0000"),
        BLACK = new("black", "000000")
      ]

      def ==(other)
        name == other.name
      end
    end
  end
end
