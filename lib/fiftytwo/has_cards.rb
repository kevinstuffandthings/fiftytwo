# frozen_string_literal: true

module FiftyTwo
  module HasCards
    extend Enumerable
    attr_reader :cards
    delegate :shuffle!, :sort!, :<<, :[], :each, :map, :count, :first, :last, to: :cards

    CardUnavailableError = Class.new(StandardError)

    def initialize(cards = [])
      @cards = cards
    end

    def draw
      cards.shift
    end

    def render
      map(&:render).join(" ")
    end

    def locate(identifier)
      cards.find { |c| c.identifier == identifier.upcase }
    end

    def transfer(card, destination = nil)
      card = locate(card) unless card.is_a?(FiftyTwo::Card)
      raise CardUnavailableError if card.nil?
      raise CardUnavailableError unless cards.include?(card)
      (destination || card.deck) << cards.delete(card)
    end

    FiftyTwo::Suit::ALL.each do |suit|
      define_method(suit.name) { select(suit.name) }
    end

    FiftyTwo::Suit::Color::ALL.each do |color|
      define_method(color.name.pluralize) { select(color.name) }
    end

    [*FiftyTwo::Rank::CATEGORIES, :jack, :king, :queen, :ace].each do |category|
      define_method(category.to_s.pluralize) { select(category) }
    end

    private

    def select(identifier)
      self.class.new(cards.select { |c| c.send("#{identifier}?") })
    end
  end
end
