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
      Player.menber.each do |player|
        Hand.add_hand(player, @cards.pop)
      end
    end
  end
end

class Field  #場のカードを管理する
  def initialize
    @field_cards = {}
  end

  def deposit(card)
    #ターンの始めにカードが場に出される
  end

  def self.push(card,player)
    Hand.push_hand(player)
  end
  
  
end

class Player #プレーヤーを管理する
  attr_reader :name
  @@menber = []

  def initialize(name)
    @name = name
    @@menber << self
    Hand.new(self)
  end

  def self.menber
    @@menber
  end
end

class Hand  #手札を管理する
  @@hand = {}
  def initialize(player)
    @player = player
    @@hand[player] = []
  end

  def self.add_hand(player, card)
    @@hand[player] << card
  end

  def self.shift_hand(player)
    @@hand[player].shift
  end

  def self.push_hand(player)
    @@hand[player].push
  end
  
  def self.menber_hand(menber)
    @@number_of_cards = {}
    menber.each do |player|
      @@number_of_cards[player] = @@hand[player].length
    end
    return @@number_of_cards
  end

  def self.minimum_hand(menber)
    self.menber_hand(menber)
    return @@number_of_cards.min_by{|k, v| v}[1]
  end

end

class Game #ゲームの進行を管理する
  def turn #1ターンの流れ
    @@draw_frag = 0 #2以上になったときは引き分けの処理
    while @@draw_frag != 1
      @@draw_frag = 0
      @@field = {}
      puts '戦争！'
      Player.menber.each do |player|
        @@field[player] = Hand.shift_hand(player)
      end

      @@winner = @@field.max_by{|k, v| v.rank }

      @@field.each do |player, card|
        if @@winner[1].rank == card.rank
          @@draw_frag += 1
        end
        print "#{player.name}のカードは「#{card.suit}#{card.rank}」\n"
      end
      if @@draw_frag > 1
        puts "引き分けです．"
      else
        puts "#{@@winner[0].name}の勝利．#{@@winner[0].name}はカードを貰いました．"
      end
    end
  end

  def duel #勝敗が決定するまでの一連の流れ
    while Hand.minimum_hand(Player.menber) > 0
      self.turn
    end
    puts Hand.menber_hand(Player.menber)
  end

end

deck = Deck.new
field = Field.new
player1 = Player.new('player1')
player2 = Player.new('player2')
deck.deal
game = Game.new
game.duel