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

  def self.hand_to_field
    Place.all_place.each do |place|
      place.bundle_of_card[:field] << place.bundle_of_card[:hand].pop
      print " #{place.player.name} => #{place.bundle_of_card[:field][-1].suit}#{place.bundle_of_card[:field][-1].rank}\n"
    end
    # print Place.all_place # for debug
  end

  def self.field_to_deposit(winner_index)
    return if winner_index.nil?

    count = 0
    Place.all_place.each do |place|
      until place.bundle_of_card[:field].empty?
        Place.all_place[winner_index].bundle_of_card[:deposit] << place.bundle_of_card[:field].pop
        count += 1
      end
    end
    puts "#{Place.all_place[winner_index].player.name}はカードを#{count}枚もらいました．"
    # ################################################### for debug
    # temp = []
    # Place.all_place.each do |place|
    #   temp << place.bundle_of_card[:deposit].length
    # end
    # puts "デポジットは#{temp}"
    # ##################################################
  end

  def self.deposit_to_hand
    Place.all_place.each do |place|
      next unless place.bundle_of_card[:hand].empty?

      place.bundle_of_card[:hand].shuffle!
      place.bundle_of_card[:hand] << place.bundle_of_card[:deposit].pop until place.bundle_of_card[:deposit].empty?
    end
  end

  def self.count_the_number_of_hands
    num_of_cards_list = []
    Place.all_place.each do |place|
      num_of_cards_list << place.bundle_of_card[:hand].length
    end
    # print "#{num_of_cards_list}\n" # for debug
    num_of_cards_list
  end
end
