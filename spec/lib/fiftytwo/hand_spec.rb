# frozen_string_literal: true

module FiftyTwo
  describe Hand do
    # majority covered by tests for FiftyTwo::Deck

    let(:deck) { FiftyTwo::Deck.standard }
    let(:hand) { described_class.new }
    before(:each) { deck.shuffle! }

    describe "#release" do
      it "does nothing with an empty hand" do
        expect(deck.count).to eq 52
        expect(hand.count).to eq 0

        hand.release

        expect(deck.count).to eq 52
        expect(hand.count).to eq 0
      end

      context "with cards" do
        before(:each) { deck.deal(hand, 5) }

        it "can return the entirety of the hand back to the deck from whence it came" do
          expect(deck.count).to eq 47
          expect(hand.count).to eq 5

          hand.release

          expect(deck.count).to eq 52
          expect(hand.count).to eq 0
        end
      end
    end
  end
end
