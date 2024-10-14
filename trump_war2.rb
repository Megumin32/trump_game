class Card # カードを管理する
  SUITS = ['♠', '♣', '◆', '♥']
  RANK = %w[2 3 4 5 6 7 8 9 10 J Q K A]
  POWER = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
  def initialize(suit, rank, power)
    @suit = suit
    @rank = rank
    @power = power
  end
end

class Deck # デッキを管理する
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def collect_card(card)
    @cards << card
  end

  def shuffle
    @cards.shuffle
  end

  def pop
    @cards.pop
  end
end

module CreateDeck # デッキを生成する
  def create_deck(deck)
    Card::SUITS.each do |suit|
      Card::RANK.each do |rank|
        deck.collect_card(Card.new(suit, rank, Card::POWER[Card::RANK.index(rank)]))
      end
    end
    deck.shuffle
  end
  module_function :create_deck
end

class Field # 場を管理する
  def initialize
    @cards = {}
    @deposit = []
  end
end

class Hand # 手札を管理する
  def initialize
    @cards = []
  end
end

class Player # プレーヤーを管理する
  def initialize(name)
    @name = name
  end
end

class Member # メンバーを管理する
  def initialize
    @players = []
  end
end

class Game # ゲームの進行を管理する
end

deck = Deck.new
CreateDeck.create_deck(deck)
