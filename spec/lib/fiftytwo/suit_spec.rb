# frozen_string_literal: true

module FiftyTwo
  describe Suit do
    describe "::ALL" do
      let(:subject) { described_class::ALL }

      it "has 4 suits" do
        expect(subject.length).to eq 4
        subject.each { |s| expect(s).to be_a described_class }
        expect(subject.map(&:name)).to eq %w[clubs diamonds hearts spades]
      end
    end

    describe "::CLUBS" do
      let(:subject) { described_class::CLUBS }

      it "is color-aware" do
        expect(subject).to be_black
        expect(subject).not_to be_red
      end

      it "is suit-aware" do
        expect(subject).to be_clubs
        expect(subject).not_to be_diamonds
        expect(subject).not_to be_hearts
        expect(subject).not_to be_spades
      end

      it "has known serializations" do
        expect(subject.to_s).to eq "Clubs"
        expect(subject.identifier).to eq "C"
      end
    end

    describe "::DIAMONDS" do
      let(:subject) { described_class::DIAMONDS }

      it "is color-aware" do
        expect(subject).not_to be_black
        expect(subject).to be_red
      end

      it "is suit-aware" do
        expect(subject).not_to be_clubs
        expect(subject).to be_diamonds
        expect(subject).not_to be_hearts
        expect(subject).not_to be_spades
      end

      it "has known serializations" do
        expect(subject.to_s).to eq "Diamonds"
        expect(subject.identifier).to eq "D"
      end
    end

    describe "::HEARTS" do
      let(:subject) { described_class::HEARTS }

      it "is color-aware" do
        expect(subject).not_to be_black
        expect(subject).to be_red
      end

      it "is suit-aware" do
        expect(subject).not_to be_clubs
        expect(subject).not_to be_diamonds
        expect(subject).to be_hearts
        expect(subject).not_to be_spades
      end

      it "has known serializations" do
        expect(subject.to_s).to eq "Hearts"
        expect(subject.identifier).to eq "H"
      end
    end

    describe "::SPADES" do
      let(:subject) { described_class::SPADES }

      it "is color-aware" do
        expect(subject).to be_black
        expect(subject).not_to be_red
      end

      it "is suit-aware" do
        expect(subject).not_to be_clubs
        expect(subject).not_to be_diamonds
        expect(subject).not_to be_hearts
        expect(subject).to be_spades
      end

      it "has known serializations" do
        expect(subject.to_s).to eq "Spades"
        expect(subject.identifier).to eq "S"
      end
    end

    context "comparable" do
      let(:subject) { described_class::ALL.shuffle }

      it "knows the logical order of suits" do
        expect(subject.sort.map(&:identifier)).to eq %w[C D H S]
      end
    end
  end
end
