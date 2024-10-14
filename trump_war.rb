class Card # カードを管理する
  @@deck = []
  SUITS = ['♠', '♣', '◆', '♥']
  RANK = %w[2 3 4 5 6 7 8 9 10 J Q K A]
  POWER = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

  def initialize(suit, rank, power)
    @suit = suit
    @rank = rank
    @power = power
    @@deck << self
  end

  def self.deck
    @@deck
  end

  def self.deck_shuffle
    @@deck.shuffle!
  end

  def self.debug
    puts @@deck
  end
end

class Player # プレーヤーを管理する
  @@member = []
  def initialize(name)
    @name = name
    @@member << self
  end

  def self.member
    @@member
  end

  def self.debug
    puts @@member
  end
end

class Hand < Card # 手札を管理する
  attr_accessor :cards

  @@all_hand = []
  def initialize(player)
    @player = player
    @cards = []
    @@all_hand << self
  end

  def self.deal
    until Card.deck.empty?
      @@all_hand.each do |hand|
        hand.cards << Card.deck.pop unless Card.deck.empty?
      end
    end
  end

  def self.debug
    print @@all_hand
  end
end

class Field < Card # 場を管理する
  attr_accessor :cards

  @@all_field = []
  def initialize(player)
    @player = player
    @cards = []
    @@all_field << self
  end

  def self.debug
    print @@all_field
  end
end

class Deposit < Card # 預かりカードを管理する
  attr_accessor :cards

  @@all_deposit = []
  def initialize(player)
    @player = player
    @cards = []
    @@all_deposit << self
  end

  def self.debug
    print @@all_deposit
  end
end

class Geme # ゲーム進行を管理する
  # 手札から１枚場に出す
  # 場のカードを比較する
  # 勝利者のデポジットに場のカードを追加する
  # カードが0になったら，デポジットをシャッフルして手札に加える
  # デポジットも0であれば，ゲームが終了する
end

Card::SUITS.each do |suit|
  Card::RANK.each do |rank|
    Card.new(suit, rank, Card::POWER[Card::RANK.index(rank)])
  end
end
Card.deck_shuffle

# print '何人で対戦しますか: '
# num = gets.chomp.to_i
# for n in 1..num do
# print "プレーヤー#{n}の名前を入力してください: "
# create(gets.chomp)
# end

# とりあえず３人
Player.new('foo') # for debug
Player.new('bar') # for debug
Player.new('baz') # for debug

Player.member.each do |player|
  Hand.new(player)
  Field.new(player)
  Deposit.new(player)
end
Hand.deal

# Card.debug
# Player.debug
# Hand.debug
# Field.debug
# Deposit.debug
