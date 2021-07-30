# frozen_string_literal: true

require_relative "./has_cards"

module FiftyTwo
  class Deck
    include HasCards

    class << self
      def standard
        build(FiftyTwo::Rank::ALL.product(FiftyTwo::Suit::ALL))
      end

      private

      def build(items)
        new.tap do |deck|
          items.each do |rank, suit|
            deck << FiftyTwo::Card.new(deck, rank, suit).freeze
          end
        end
      end
    end

    def deal(hands, num_cards = 1)
      num_cards.times.each do |card_idx|
        Array(hands).each { |h| h << draw }
      end

      hands
    end
  end
end
