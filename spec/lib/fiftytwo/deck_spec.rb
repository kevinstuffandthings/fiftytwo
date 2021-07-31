# frozen_string_literal: true

module FiftyTwo
  describe Deck do
    let(:subject) { described_class.standard }
    let(:minideck) { described_class.new }
    before(:each) do
      minideck << FiftyTwo::Card.new(minideck, FiftyTwo::Rank::THREE, FiftyTwo::Suit::CLUBS)
      minideck << FiftyTwo::Card.new(minideck, FiftyTwo::Rank::NINE, FiftyTwo::Suit::DIAMONDS)
      minideck << FiftyTwo::Card.new(minideck, FiftyTwo::Rank::TEN, FiftyTwo::Suit::DIAMONDS)
    end

    it "is a deck, made up of cards" do
      expect(subject).to be_a described_class
      expect(subject.count).to eq 52
      subject.each do |card|
        expect(card).to be_a FiftyTwo::Card
        expect(card.deck).to eq subject
      end
    end

    it "has 13 distinct ranks" do
      expect(subject.map(&:rank).uniq.count).to eq 13
    end

    it "has 4 distinct suits" do
      expect(subject.map(&:suit).uniq.count).to eq 4
    end

    it "has 2 distinct colors" do
      expect(subject.map(&:color).uniq.count).to eq 2
    end

    context "shuffling/sorting" do
      def sorted?(deck)
        is_sorted = true
        deck[1..].each_with_index do |card, i|
          is_sorted = false unless deck[i] < card
        end
        is_sorted
      end

      it "starts with cards ordered properly" do
        expect(sorted?(subject)).to be true
      end

      it "can shuffle the cards" do
        subject.shuffle!
        expect(sorted?(subject)).to be false
      end

      it "can resort the cards" do
        subject.shuffle!
        subject.sort!
        expect(sorted?(subject)).to be true
      end
    end

    context "filtering" do
      require "pry"
      it "can find diamonds" do
        cards = subject.diamonds
        expect(cards.count).to eq 13
      end

      it "can find blacks" do
        cards = subject.blacks
        expect(cards.count).to eq 26
      end

      it "can find pips" do
        cards = subject.pips
        expect(cards.count).to eq 40
      end

      it "can find faces" do
        cards = subject.faces
        expect(cards.count).to eq 12
      end

      it "can find jacks" do
        cards = subject.jacks
        expect(cards.count).to eq 4
      end

      it "can find queens" do
        cards = subject.queens
        expect(cards.count).to eq 4
      end

      it "can find kings" do
        cards = subject.kings
        expect(cards.count).to eq 4
      end

      it "can find aces" do
        cards = subject.aces
        expect(cards.count).to eq 4
      end

      it "can find red faces" do
        cards = subject.reds.faces
        expect(cards.count).to eq 6
      end

      it "can find black jacks" do
        cards = subject.jacks.blacks
        expect(cards.count).to eq 2
      end

      it "can find pip spades" do
        cards = subject.pips.spades
        expect(cards.count).to eq 10
      end
    end

    describe "#draw" do
      let(:subject) { minideck }

      it "takes cards in order from the deck" do
        expect(subject.count).to eq 3

        card = subject.draw
        expect(subject.count).to eq 2
        expect(card).to be_a FiftyTwo::Card
        expect(card.identifier).to eq "3C"

        card = subject.draw
        expect(subject.count).to eq 1
        expect(card).to be_a FiftyTwo::Card
        expect(card.identifier).to eq "9D"

        card = subject.draw
        expect(subject.count).to eq 0
        expect(card).to be_a FiftyTwo::Card
        expect(card.identifier).to eq "10D"

        card = subject.draw
        expect(subject.count).to eq 0
        expect(card).to be nil
      end
    end

    describe "#locate" do
      it "can find the 3 of diamonds via 3D" do
        card = subject.locate("3D")
        expect(card.rank).to eq FiftyTwo::Rank::THREE
        expect(card.suit).to eq FiftyTwo::Suit::DIAMONDS
      end

      it "can find the ace of spades via as" do
        card = subject.locate("as")
        expect(card.rank).to eq FiftyTwo::Rank::ACE
        expect(card.suit).to eq FiftyTwo::Suit::SPADES
      end

      it "can find the 10 of clubs via 10C" do
        card = subject.locate("10C")
        expect(card.rank).to eq FiftyTwo::Rank::TEN
        expect(card.suit).to eq FiftyTwo::Suit::CLUBS
      end

      it "returns nil on a nonsense code" do
        card = subject.locate("MITTENS")
        expect(card).to be nil
      end

      context "removed card" do
        let(:subject) { minideck }

        it "returns nil if the card is not currently in the deck" do
          card = minideck.locate("10C")
          expect(card).to be nil
        end
      end
    end

    describe "#transfer" do
      let(:subject) { minideck }
      let(:hand) { FiftyTwo::Hand.new }

      it "has a deck with 2 cards, and a hand with none" do
        expect(subject.count).to eq 3
        expect(hand.count).to eq 0
      end

      it "can transfer a card by object" do
        subject.transfer(subject[1], hand)
        expect(subject.map(&:identifier)).to match_array ["3C", "10D"]
        expect(hand.map(&:identifier)).to match_array ["9D"]
      end

      it "can transfer a card by identifier" do
        subject.transfer("3C", hand)
        expect(subject.map(&:identifier)).to match_array ["9D", "10D"]
        expect(hand.map(&:identifier)).to match_array ["3C"]
      end

      it "can transfer a card by index" do
        subject.transfer(0, hand)
        expect(subject.map(&:identifier)).to match_array ["9D", "10D"]
        expect(hand.map(&:identifier)).to match_array ["3C"]
      end

      it "can transfer multiple cards" do
        subject.transfer(%w[3C 10D], hand)
        expect(subject.map(&:identifier)).to match_array ["9D"]
        expect(hand.map(&:identifier)).to match_array ["3C", "10D"]
      end

      it "can transfer multiple cards by a variety of identification methods" do
        subject.transfer(["3C", 1], hand)
        expect(subject.map(&:identifier)).to match_array ["10D"]
        expect(hand.map(&:identifier)).to match_array ["3C", "9D"]
      end

      it "will not transfer any and raise an error if any one card reference is invalid" do
        expect { subject.transfer(%w[3C 10K], hand) }.to raise_error FiftyTwo::HasCards::CardUnavailableError
        expect(subject.count).to eq 3
        expect(hand.count).to eq 0
      end

      context "missing card" do
        let(:missing_card) { FiftyTwo::Card.new(subject, FiftyTwo::Rank::THREE, FiftyTwo::Suit::HEARTS) }

        it "raises an error on a card not in the deck" do
          expect { subject.transfer(missing_card, hand) }.to raise_error FiftyTwo::HasCards::CardUnavailableError
        end

        it "raises an error on an identifier not in the deck" do
          expect { subject.transfer(missing_card.identifier, hand) }.to raise_error FiftyTwo::HasCards::CardUnavailableError
        end
      end

      context "back to originating deck" do
        let(:card) { subject[1] }
        before(:each) { subject.transfer(card, hand) }

        it "starts with a card in the hand and 2 in the deck" do
          expect(subject.count).to eq 2
          expect(hand.count).to eq 1
        end

        it "can transfer a card from a hand back to the bottom of its originating deck" do
          hand.transfer(card)
          expect(subject.count).to eq 3
          expect(hand.count).to eq 0
          expect(subject.last).to eq card
        end
      end
    end

    describe "#render" do
      let(:subject) { minideck }

      before(:each) do
        minideck.cards.each_with_index do |card, i|
          allow(card).to receive(:render).and_return "CARD#{i}"
        end
      end

      it "renders the set of cards in this deck" do
        expect(subject.render).to eq "CARD0 CARD1 CARD2"
      end
    end

    describe "#deal" do
      let(:hand1) { FiftyTwo::Hand.new }
      let(:hand2) { FiftyTwo::Hand.new }
      let(:hand3) { FiftyTwo::Hand.new }
      let(:hands) { [hand1, hand2, hand3] }
      before(:each) { subject.shuffle! }

      it "starts out as expected" do
        expect(subject.count).to eq 52
        hands.each { |h| expect(h.count).to eq 0 }
      end

      it "can deal a single card to variety of hands" do
        card1 = subject[0]
        card2 = subject[1]
        card3 = subject[2]

        subject.deal(hands)
        expect(subject.count).to eq 49
        expect(hand1.cards).to match_array [card1]
        expect(hand2.cards).to match_array [card2]
        expect(hand3.cards).to match_array [card3]
      end

      it "can deal multiple cards to a variety of hands" do
        card1 = subject[0]
        card2 = subject[1]
        card3 = subject[2]
        card4 = subject[3]
        card5 = subject[4]
        card6 = subject[5]
        card7 = subject[6]
        card8 = subject[7]
        card9 = subject[8]

        subject.deal(hands, 3)
        expect(subject.count).to eq 43
        expect(hand1.cards).to match_array [card1, card4, card7]
        expect(hand2.cards).to match_array [card2, card5, card8]
        expect(hand3.cards).to match_array [card3, card6, card9]
      end
    end
  end
end
