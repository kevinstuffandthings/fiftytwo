# frozen_string_literal: true

module FiftyTwo
  class Rank
    include Comparable
    CATEGORIES = %i[pip face]

    attr_reader :value, :name, :category

    def initialize(value, name = nil, category = :pip)
      @value = value
      @name = name || value.to_s
      @category = category
    end

    ALL = [
      TWO = Rank.new(2).freeze,
      THREE = Rank.new(3).freeze,
      FOUR = Rank.new(4).freeze,
      FIVE = Rank.new(5).freeze,
      SIX = Rank.new(6).freeze,
      SEVEN = Rank.new(7).freeze,
      EIGHT = Rank.new(8).freeze,
      NINE = Rank.new(9).freeze,
      TEN = Rank.new(10).freeze,
      JACK = Rank.new(11, "jack", :face).freeze,
      QUEEN = Rank.new(12, "queen", :face).freeze,
      KING = Rank.new(13, "king", :face).freeze,
      ACE = Rank.new(14, "ace").freeze
    ]

    CATEGORIES.each do |category|
      define_method("#{category}?") { self.category == category }
    end

    ALL.select(&:face?).each do |rank|
      define_method("#{rank.name}?") { self == rank }
    end

    def ace?
      name == "ace"
    end

    def <=>(other)
      value <=> other.value
    end

    def to_s
      name.titleize
    end

    def identifier
      name.to_i > 0 ? name : name[0].upcase
    end
    alias_method :code, :identifier
  end
end
