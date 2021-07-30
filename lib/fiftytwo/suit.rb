# frozen_string_literal: true

require_relative "./suit/color"

module FiftyTwo
  class Suit
    include Comparable

    attr_reader :name, :color, :symbol
    alias_method :code, :symbol

    def initialize(name, color, symbol = nil)
      @name = name
      @color = color
      @symbol = symbol
    end

    ALL = [
      CLUBS = Suit.new("clubs", Color::BLACK, "♣").freeze,
      DIAMONDS = Suit.new("diamonds", Color::RED, "♦").freeze,
      HEARTS = Suit.new("hearts", Color::RED, "♥").freeze,
      SPADES = Suit.new("spades", Color::BLACK, "♠").freeze
    ]

    Color::ALL.each do |color|
      define_method("#{color.name}?") { self.color == color }
    end

    ALL.each do |suit|
      define_method("#{suit.name.downcase}?") { self == suit }
    end

    def <=>(other)
      name <=> other.name
    end

    def to_s
      name.titleize
    end

    def identifier
      name[0].upcase
    end
  end
end
