class Card
  SUITS = ['♠', '♣', '◆', '♥']
  RANKS = %w[A 2 3 4 5 6 7 8 9 10 J Q K]
  STRENGTH = [13, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  attr_reader :suit, :rank, :strength

  @@deck = []

  def initialize(suit, rank, strength)
    @suit = suit
    @rank = rank
    @strength = strength
  end

  def self.deck
    @@deck
  end

  def self.deck_pop
    @@deck.pop
  end

  def override_strength(num)
    @strength = num
  end

  def self.generate_cards
    SUITS.each do |suit|
      RANKS.each do |rank|
        @@deck << Card.new(suit, rank, STRENGTH[RANKS.index(rank)])
      end
    end
    @@deck << Card.new('Joker', '', 15)
    @@deck[0].override_strength(14) # スペードのエースの強さを上書き
    # print @@deck # for debug
  end

  def self.make_a_deck
    @@deck.shuffle!
  end
end
