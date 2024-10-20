class Place
  attr_accessor :bundle_of_card
  attr_reader :player

  @@all_place = []
  def initialize(player)
    @player = player
    @bundle_of_card = { field: [], hand: [], stock: [] }
    @@all_place << self
  end

  def self.all_place
    @@all_place
  end

  def self.hand_to_field
    pair_of_spades = 0
    Place.all_place.each do |place|
      fi = place.bundle_of_card[:field]
      ha = place.bundle_of_card[:hand]
      fi << ha.pop
      print " #{place.player.name} => #{fi[-1].name}\n"
      ############### スペードのエース判定
      if fi[-1].strength == 13
        pair_of_spades += 1
      elsif fi[-1].strength == 14
        pair_of_spades += 10
      end
      #################################
    end
    puts '♠Aは世界一！' if pair_of_spades > 10
    pair_of_spades = 0
  end

  def self.field_to_stock(winner_index)
    return if winner_index.nil?

    count = 0
    Place.all_place.each do |place|
      fi = place.bundle_of_card[:field]
      until fi.empty?
        Place.all_place[winner_index].bundle_of_card[:stock] << fi.pop
        count += 1
      end
    end
    puts "#{Place.all_place[winner_index].player.name}はカードを#{count}枚もらいました．"
  end

  def self.stock_to_hand
    Place.all_place.each do |place|
      ha = place.bundle_of_card[:hand]
      st = place.bundle_of_card[:stock]
      next unless ha.empty?

      st.shuffle!
      ha << st.pop until st.empty?
    end
  end

  def self.count_the_number_of_hands
    num_of_cards_list = []
    Place.all_place.each do |place|
      num_of_cards_list << place.bundle_of_card[:hand].length
    end
    num_of_cards_list
  end
end
