# frozen_string_literal: true

require_relative "./has_cards"

module FiftyTwo
  class Hand
    include HasCards

    def release
      cards.reverse_each { |c| transfer(c) }
    end
  end
end
