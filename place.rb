class Place
  attr_accessor :bundle_of_card
  attr_reader :player

  @@all_place = []
  def initialize(player)
    @player = player
    @bundle_of_card = { field: [], hand: [], deposit: [] }
    @@all_place << self
  end

  def self.all_place
    @@all_place
  end
end
