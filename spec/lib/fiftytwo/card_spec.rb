# frozen_string_literal: true

module FiftyTwo
  describe Card do
    let(:deck) { instance_double(FiftyTwo::Deck) }
    let(:rank) { instance_double(FiftyTwo::Rank, code: "RC", identifier: "RI", to_s: "92") }
    let(:suit) { instance_double(FiftyTwo::Suit, code: "SC", identifier: "SI", to_s: "Mittens") }
    let(:subject) { described_class.new(deck, rank, suit) }

    it "exposes its basics" do
      expect(subject.deck).to eq deck
      expect(subject.rank).to eq rank
      expect(subject.suit).to eq suit
    end

    it "has a variety of serializations" do
      expect(subject.code).to eq "RCSC"
      expect(subject.identifier).to eq "RISI"
      expect(subject.to_s).to eq "92 of Mittens"
    end

    describe "#render" do
      let(:color) { instance_double(FiftyTwo::Suit::Color, name: "blue") }
      before(:each) { allow(suit).to receive(:color).and_return color }

      it "builds a proper rendering from 2 characters" do
        allow(subject).to receive(:code).and_return "XY"
        expect(subject.render).to eq "\e[0;34;49m XY\e[0m"
      end

      it "builds a proper rendering from 3 characters" do
        allow(subject).to receive(:code).and_return "XYZ"
        expect(subject.render).to eq "\e[0;34;49mXYZ\e[0m"
      end
    end

    context "questions" do
      before(:each) do
        allow(rank).to receive(:face?).and_return "grumpy"
        allow(rank).to receive(:pip?).and_return "pip hooray"
        allow(suit).to receive(:red?).and_return "roses"
        allow(suit).to receive(:diamonds?).and_return "drip"
      end

      it "can answer questions only its rank knows" do
        expect(subject.face?).to eq "grumpy"
        expect(subject.pip?).to eq "pip hooray"
      end

      it "can answer questions only its suit knows" do
        expect(subject.red?).to eq "roses"
        expect(subject.diamonds?).to eq "drip"
      end

      it "will not answer silly questions" do
        subject.hungry?
      rescue NoMethodError
      end
    end

    context "comparable" do
      context "different rank, different suit" do
        it "orders by rank first" do
          card1 = described_class.new(deck, FiftyTwo::Rank::FOUR, FiftyTwo::Suit::CLUBS)
          card2 = described_class.new(deck, FiftyTwo::Rank::TWO, FiftyTwo::Suit::DIAMONDS)
          expect(card2).to be < card1
        end
      end

      context "different rank, same suit" do
        it "orders by rank first" do
          card1 = described_class.new(deck, FiftyTwo::Rank::FOUR, FiftyTwo::Suit::SPADES)
          card2 = described_class.new(deck, FiftyTwo::Rank::SEVEN, FiftyTwo::Suit::SPADES)
          expect(card2).to be > card1
        end
      end

      context "same rank, different suit" do
        it "orders by suit" do
          card1 = described_class.new(deck, FiftyTwo::Rank::KING, FiftyTwo::Suit::SPADES)
          card2 = described_class.new(deck, FiftyTwo::Rank::KING, FiftyTwo::Suit::HEARTS)
          expect(card2).to be < card1
        end
      end

      context "same rank, same suit" do
        it "calls it a tie" do
          card1 = described_class.new(deck, FiftyTwo::Rank::TEN, FiftyTwo::Suit::DIAMONDS)
          card2 = described_class.new(deck, FiftyTwo::Rank::TEN, FiftyTwo::Suit::DIAMONDS)
          expect(card2).to eq card1
        end
      end
    end
  end
end
