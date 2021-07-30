# frozen_string_literal: true

require "colorize"

module FiftyTwo
  class Card
    include Comparable

    attr_reader :deck, :rank, :suit
    delegate :color, to: :suit

    def initialize(deck, rank, suit)
      @deck = deck
      @rank = rank
      @suit = suit
    end

    def code
      "#{rank.code}#{suit.code}"
    end

    def to_s
      "#{rank} of #{suit}"
    end
    alias_method :name, :to_s

    def identifier
      "#{rank.identifier}#{suit.identifier}"
    end

    def render
      code.rjust(3).send(suit.color.name)
    end

    def <=>(other)
      [rank, suit] <=> [other.rank, other.suit]
    end

    def method_missing(name, **args, &block)
      return super unless name.to_s.ends_with?("?")

      attributes.each do |attribute|
        return attribute.send(name) if attribute.respond_to?(name)
      end

      super
    end

    def respond_to_missing?(name, include_private = false)
      return false unless name.to_s.ends_with?("?")
      return false unless attributes.any? { |a| a.respond_to?(name) }
    end

    private

    def attributes
      [rank, suit]
    end
  end
end
