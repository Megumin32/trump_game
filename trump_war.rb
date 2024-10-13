class Card #カードを管理する
  SUITS = ['♠', '♣', '◆', '♥']
  RANK = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  POWER = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

  attr_reader :suit, :rank, :power
  
  def initialize(suit, rank, power)
    @suit = suit
    @rank = rank
    @power = power
  end
end

class Deck < Card #デッキを管理する
  def initialize
    @cards = []
    SUITS.each do |suit|
      RANK.each do |rank|
        @cards << Card.new(suit, rank, POWER[RANK.index(rank)])
      end
    end
    @cards.shuffle!
  end

  def deal
    puts "戦争を開始します．\nカードが配られました．"
    while !@cards.empty?
      Player.member.each do |player|
        Hand.start(player, @cards.pop)
      end
    end
  end
end

class Field  #場のカードを管理する
  @@deposit = []
  @@field = {}
  def initialize(player)
    @@field[player] = ""
  end

  def self.save(player)
    @@field[player] = Hand.play(player)
  end

  def self.give(player)
    @@deposit.each do |k, card|
      Hand.take(player,card)
    end
  end
  
  def self.deposit
    @@field.each do |player, card|
      @@deposit.push(card)
    dnd
  end
end

class Player #プレーヤーを管理する
  attr_reader :name
  @@member = []

  def initialize(name)
    @name = name
    @@member << self
    Hand.new(self)
    Field.new(self)
  end

  def self.member
    @@member
  end
end

class Hand  #手札を管理する
  @@hand = {}
  def initialize(player)
    @player = player
    @@hand[player] = []
  end

  def self.start(player, card)
    @@hand[player] << card
  end

  def self.play(player)
    @@hand[player].shift
  end

  def self.take(player,card)
    @@hand[player].push(card)
  end
  
  def self.member_hand(member)
    @@number_of_cards = {}
    Player.member.each do |player|
      @@number_of_cards[player] = @@hand[player].length
    end
    return @@number_of_cards
  end

  def self.minimum_hand(member)
    return self.member_hand(member).min_by{|k, v| v}[1]
  end

end

class Game #ゲームの進行を管理する
  def turn #1ターンの流れ
    @draw_frag = 0 #2以上になったときは引き分けの処理
    while @draw_frag != 1
      @draw_frag = 0
      puts '戦争！'
      Player.member.each do |player|
        Field.save(player)
      end

      @winner = field.max_by{|k, v| v.power }

      Field.deposit.each do |player, card|
        if @winner[1].rank == card.rank
          @draw_frag += 1
        end
        print "#{player.name}のカードは「#{card.suit}#{card.rank}」\n"
      end
      if @draw_frag > 1
        puts "引き分けです．"
      else
        puts "#{@winner[0].name}の勝利．#{@winner[0].name}はカードを貰いました．"
        field.give(@winner[0])
      end
    end
  end

  def duel #勝敗が決定するまでの一連の流れ
    while Hand.minimum_hand(Player.member) > 0
      self.turn
      puts Hand.member_hand(Player.member)
    end
  end

end

deck = Deck.new
player1 = Player.new('player1')
player2 = Player.new('player2')
deck.deal
game = Game.new
game.turn