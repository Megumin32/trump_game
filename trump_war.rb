class Card # カードを管理する
  attr_reader :suit, :rank, :power

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
end

class Player # プレーヤーを管理する
  attr_reader :name

  @@member = []
  def initialize(name)
    @name = name
    @@member << self
  end

  def self.member
    @@member
  end
end

class Hand < Card # 手札を管理する
  attr_accessor :cards

  @@all_hand = []
  @@hand_num = []
  def initialize(player)
    @player = player
    @cards = []
    @@all_hand << self
  end

  def self.deal
    puts '戦争を開始します．カードを配ります．'
    until Card.deck.empty?
      @@all_hand.each do |hand|
        hand.cards << Card.deck.pop unless Card.deck.empty?
      end
    end
  end

  def self.all_hand
    @@all_hand
  end

  def self.hand_count
    @@all_hand.each do |hand|
      @@hand_num << hand.cards.length
    end
    @@hand_num
  end

  def self.hand_num
    @@hand_num
  end

  def self.hand_num_replace(index)
    @@hand_num[index] = -1
  end

  def self.continue
    @@all_hand.each do |hand|
      if hand.cards.length == 0
        puts "#{Player.member[@@all_hand.index(hand)].name}の手札がなくなりました．"
        return false
      end
    end
  end

  def pop
    @cards.pop
  end

  def push(card)
    @cards.push(card)
  end
end

class Field < Card # 場を管理する
  attr_accessor :cards

  @@all_field = []
  @@temporary_field = []

  def initialize(player)
    @player = player
    @card = ''
    @@all_field << self
  end

  def self.all_field
    @@all_field
  end

  def self.temporary_field
    @@temporary_field
  end

  def self.all_power
    @@all_power = []
    @@all_field.each do |card|
      @@all_power << card.power
    end
    # print @@all_power # for debug
    @@all_power
  end

  def pop
    @card.pop
  end

  def push(card)
    @card = card
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

  def self.all_deposit
    @@all_deposit
  end

  def pop
    @cards.pop
  end

  def push(card)
    @cards.push(card)
  end
end

module Game # ゲーム進行を管理する
  @@winner_num = nil

  def play
    puts '戦争！'
    for i in 0..Player.member.length - 1 do
      Field.all_field[i] = Hand.all_hand[i].cards.pop
      print " #{Player.member[i].name} => #{Field.all_field[i].suit}#{Field.all_field[i].rank}\n"
    end
  end

  def judgment
    max_power = Field.all_power.max
    max_index = Field.all_power.index(max_power)
    if Field.all_power.count(max_power) > 1
      puts '引き分けです'
      @@winner_index = nil
    else
      print "#{Player.member[max_index].name}の勝ち．"
      @@winner_index = max_index
    end
  end

  def distribute
    if @@winner_index.nil?
      Field.all_field.each do |card|
        Field.temporary_field << card
      end
    else
      num = Field.all_field.length + Field.temporary_field.length
      for i in 1..Field.all_field.length do
        Deposit.all_deposit[@@winner_index].cards.push(Field.all_field.pop)
      end
      for i in 1..Field.temporary_field.length do
        Deposit.all_deposit[@@winner_index].cards.push(Field.temporary_field.pop)
      end
      print "#{Player.member[@@winner_index].name}はカードを#{num}枚もらいました．\n"
    end
  end

  def replenish_card(index)
    Deposit.all_deposit[index].cards.shuffle!
    for i in 1..Deposit.all_deposit[index].cards.length
      Hand.all_hand[index].cards.push(Deposit.all_deposit[index].cards.pop)
    end
  end

  def result
    puts '【結果発表】'
    Hand.hand_count
    # print Hand.hand_num # for debug
    for i in 1..Player.member.length
      puts "#{i}位 => #{Player.member[Hand.hand_num.index(Hand.hand_num.max)].name}"
      Hand.hand_num_replace(Hand.hand_num.index(Hand.hand_num.max))
      # print Hand.hand_num #for debug
    end
  end
  module_function :play, :judgment, :distribute, :replenish_card, :result
end

# ここから実行 ##############################################################3
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

# for debug ##############################
Player.new('Alfred')
Player.new('Bertrand')
Player.new('Catherine')
Player.new('Diana')
Player.new('Elizabeth')
##########################################

Player.member.each do |player|
  Hand.new(player)
  Field.new(player)
  Deposit.new(player)
end
Hand.deal

while Hand.continue
  # Hand.hand_count # for debug
  Game.play
  Game.judgment
  Game.distribute
  Hand.all_hand.each do |hand|
    Game.replenish_card(Hand.all_hand.index(hand)) if hand.cards.empty?
  end
end

Game.result
