class Card #カードを管理する
  @@suits = ['♠','♣','◆','♥']
  @@rank_list = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
  @@power_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

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
    @@suits.each do |suit|
      @@rank_list.each do |rank|
        @cards << Card.new(suit,rank,@@power_list[@@rank_list.index(rank)])
      end
    end
    @cards.shuffle!
  end

  def deal 
    puts "戦争を開始します．\nカードが配られました．"
    while !@cards.empty?
      Player.menber.each do |player|
        player.hand << @cards.pop
      end
    end
    # デバッグ用
    # Player.menber.each do |player|
      # print "player.name\n"
      # player.hand.each do |card|
        # print "#{card.suit}#{card.rank}\n"
      # end
    # end
  end
end

class Player #プレーヤーを管理する
  attr_accessor :name, :hand
  @@menber = []

  def initialize(name)
    @name = name 
    @@menber << self
    @hand = []
  end

  def self.menber
    @@menber
  end
end

class Game #ゲームの進行を管理する
  def duel
    @@draw_frag = 0 #2以上になったときは引き分けの処理
    while @@draw_frag != 1
      @@draw_frag = 0
      @@field = {}
      puts '戦争！'
      Player.menber.each do |player|
        @@field[player] = player.hand.pop
      end

      @@winner = @@field.max_by{ |k,v| v.rank }

      @@field.each do |player, card|
        if @@winner[1].rank == card.rank
          @@draw_frag += 1
        end
        print "#{player.name}のカードは「#{card.suit}#{card.rank}」\n"
      end
      if @@draw_frag > 1 
        puts "引き分けです．"
      else
        puts "#{@@winner[0].name}の勝利．\n戦争を終了します．" 
      end
    end
  end
end

deck = Deck.new
player1 = Player.new('player1')
player2 = Player.new('player2')
deck.deal
game = Game.new
game.duel