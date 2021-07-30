# frozen_string_literal: true

module FiftyTwo
  describe Rank do
    describe "::ALL" do
      let(:subject) { described_class::ALL }

      it "has a list of all available ranks" do
        expect(subject.length).to eq 13
        subject.each { |r| expect(r).to be_a described_class }
      end

      it "has all values represented" do
        expect(subject.map(&:value)).to eq (2..14).to_a
      end
    end

    context "numbers" do
      let(:subject) { described_class::ALL.select(&:pip?).reject(&:ace?) }

      it "is composed of rank objects" do
        expect(subject.count).to eq 9
        subject.each { |r| expect(r).to be_a described_class }
      end

      it "has pips 2-10" do
        (2..10).each do |value|
          rank = subject[value - 2]
          expect(rank.value).to eq value
          expect(rank.name).to eq value.to_s
          expect(rank.to_s).to eq rank.name
          expect(rank.code).to eq rank.name
          expect(rank.identifier).to eq rank.name
          expect(rank).to be_pip
          expect(rank).not_to be_face
          expect(rank).not_to be_jack
          expect(rank).not_to be_queen
          expect(rank).not_to be_king
          expect(rank).not_to be_ace
        end
      end
    end

    context "faces" do
      let(:subject) { described_class::ALL.select(&:face?) }

      it "is composed of rank objects" do
        expect(subject.count).to eq 3
        subject.each { |r| expect(r).to be_a described_class }
      end

      it "has a jack" do
        rank = subject[0]
        expect(rank.value).to eq 11
        expect(rank.name).to eq "jack"
        expect(rank.to_s).to eq "Jack"
        expect(rank.code).to eq "J"
        expect(rank.identifier).to eq "J"
        expect(rank).not_to be_pip
        expect(rank).to be_face
        expect(rank).to be_jack
        expect(rank).not_to be_queen
        expect(rank).not_to be_king
        expect(rank).not_to be_ace
      end

      it "has a queen" do
        rank = subject[1]
        expect(rank.value).to eq 12
        expect(rank.name).to eq "queen"
        expect(rank.to_s).to eq "Queen"
        expect(rank.code).to eq "Q"
        expect(rank.identifier).to eq "Q"
        expect(rank).not_to be_pip
        expect(rank).to be_face
        expect(rank).not_to be_jack
        expect(rank).to be_queen
        expect(rank).not_to be_king
        expect(rank).not_to be_ace
      end

      it "has a king" do
        rank = subject[2]
        expect(rank.value).to eq 13
        expect(rank.name).to eq "king"
        expect(rank.to_s).to eq "King"
        expect(rank.code).to eq "K"
        expect(rank.identifier).to eq "K"
        expect(rank).not_to be_pip
        expect(rank).to be_face
        expect(rank).not_to be_jack
        expect(rank).not_to be_queen
        expect(rank).to be_king
        expect(rank).not_to be_ace
      end
    end

    context "aces" do
      let(:subject) { described_class::ACE }

      it "is a rank object" do
        expect(subject).to be_a described_class
      end

      it "is an ace through and through" do
        expect(subject.value).to eq 14
        expect(subject.name).to eq "ace"
        expect(subject.to_s).to eq "Ace"
        expect(subject.code).to eq "A"
        expect(subject.identifier).to eq "A"
        expect(subject).to be_pip
        expect(subject).not_to be_face
        expect(subject).not_to be_jack
        expect(subject).not_to be_queen
        expect(subject).not_to be_king
        expect(subject).to be_ace
      end
    end

    context "comparable" do
      let(:subject) { described_class::ALL.shuffle }

      it "knows how to sort ranks" do
        expect(subject.sort.map(&:value)).to eq (2..14).to_a
      end
    end
  end
end
