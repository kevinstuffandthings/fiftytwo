# FiftyTwo ![Build Status](https://github.com/kevinstuffandthings/fiftytwo/actions/workflows/ruby.yml/badge.svg) [![Gem Version](https://badge.fury.io/rb/fiftytwo.svg)](https://badge.fury.io/rb/fiftytwo)

A [standard 52-card deck](https://en.wikipedia.org/wiki/Standard_52-card_deck), written in Ruby.

## Installation
Add this line to your application's Gemfile:

```ruby
# update with the version of your choice
gem 'fiftytwo'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install fiftytwo
```

## Usage
Get a deck of cards:
```ruby
require "fiftytwo"

deck = FiftyTwo::Deck.standard
# => #<FiftyTwo::Deck:0x00007f905c154b10 @cards=[...]>

deck.count
# => 52
```

Examine how neatly organized the cards are, and then do something about it:
```ruby
deck[0..7].map(&:to_s)
# => ["2 of Clubs", "2 of Diamonds", "2 of Hearts", "2 of Spades", "3 of Clubs", "3 of Diamonds", "3 of Hearts", "3 of Spades"]

deck.shuffle! # you can always deck.sort! later
deck[0..7].map(&:to_s)
# => ["5 of Diamonds", "Jack of Spades", "Ace of Hearts", "6 of Hearts", "9 of Hearts", "2 of Diamonds", "3 of Spades", "7 of Spades"]
```

Take a deep dive into a card:
```ruby
card = deck.first
# => #<FiftyTwo::Card:0x00007f905c154548 ...>

card.rank
#  => #<FiftyTwo::Rank:0x00007f9056a04068 @value=5, @name="5", @category=:pip>

card.suit
# => #<FiftyTwo::Suit:0x00007f9056a1f138 @name="diamonds", @color=#<FiftyTwo::Suit::Color:0x00007f9056a1f638 @name="red", @rgb="ff0000">, @symbol="♦">

card.red?
# => true

card.spades?
# => false

card.pip?
# => true

card.king?
# => false
```

Look for types of cards in your deck, as they are currently ordered:
```ruby
deck.kings.count
# => 4

deck.faces.reds.count
# => 6

deck.faces.reds.first.name
# => "Queen of Hearts"

deck.locate("AS").name
# => "Ace of Spades"

deck.locate("10C").name
# => "Ten of Clubs"
```

Draw a card from the deck, and give it back later:
```ruby
deck.shuffle!
card = deck.draw
# => #<FiftyTwo::Card:0x00007fb3d2284960 ...>

deck.count
# => 51
card.name
# => "9 of Diamonds"

deck << card
deck.count
# => 52
deck.last.name
# => "9 of Diamonds"
```

Deal some cards from the deck to yourself and a friend:
```ruby
my_hand = FiftyTwo::Hand.new
# => #<FiftyTwo::Hand:0x00007fb3d50ca7c0 @cards=[]>
your_hand = FiftyTwo::Hand.new
# => #<FiftyTwo::Hand:0x00007fb3d21c68c0 @cards=[]>

deck.deal([my_hand, your_hand], 5)
"Deck has #{deck.count} cards, I have #{my_hand.count} cards, you have #{your_hand.count} cards"
# => "Deck has 42 cards, I have 5 cards, you have 5 cards"

puts my_hand.render, your_hand.render # by the way renderings are colored red/black in your terminal, just like the suit!
 3♦  4♠  5♦  7♥  2♣
 6♠  A♦  5♠ 10♦  Q♣
```

Hands, just like the deck, can be shuffled, sorted, searched, etc:
```ruby
your_hand.sort!
puts your_hand.render
 5♠  6♠ 10♦  Q♣  A♦

your_hand.aces.count
# => 1
```

Pass your cards around:
```ruby
my_hand.transfer("4S", your_hand)
puts my_hand.render, your_hand.render
 3♦  5♦  7♥  2♣
 5♠  6♠ 10♦  Q♣  A♦  4♠

your_hand.transfer("QC") # goes back to the deck
puts my_hand.render, your_hand.render
 3♦  5♦  7♥  2♣
 5♠  6♠ 10♦  A♦  4♠

deck.count
# => 43
```

And finally, release your hand back to the dealer:
```ruby
my_hand.release
your_hand.release

"Deck has #{deck.count} cards, I have #{my_hand.count} cards, you have #{your_hand.count} cards"
# => "Deck has 52 cards, I have 0 cards, you have 0 cards"
```

# Problems?
Please submit an [issue](https://github.com/kevinstuffandthings/fiftytwo/issues).
We'll figure out how to get you up and running with FiftyTwo as smoothly as possible.
