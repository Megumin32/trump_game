require_relative 'card'
require_relative 'player'
require_relative 'place'

class Game
  def self.prepare_a_deck
    Card.generate_cards
    Card.make_a_deck
    # print Card.deck # for debug
  end

  def self.determine_players
    puts 'プレーヤーの人数を入力してください．（２〜５）'
    num = gets.to_i
    # 例外処理を記述

    num.times do |i|
      puts "プレーヤー#{i + 1}の名前を入力してください．"
      Player.Generate_players(gets.chomp.to_s)
    end

    Player.group.each do |player|
      Place.new(player)
    end
    # print Player.group # for debug
    # print Place.all_place # for debug
  end

  def self.deal_cards
    until Card.deck.empty?
      Place.all_place.each do |place|
        place.bundle_of_card[:hand] << Card.deck_pop
        place.bundle_of_card[:hand].compact!
      end
    end
    # print Place.all_place # for debug
  end

  def self.do_a_turn
    puts '戦争!'

    Place.all_place.each do |place|
      place.bundle_of_card[:field] << place.bundle_of_card[:hand].pop
      print " #{place.player.name} => #{place.bundle_of_card[:field][0].suit}#{place.bundle_of_card[:field][0].rank}\n"
    end
    # print Place.all_place # for debug

    strength_list = []
    Place.all_place.each do |place|
      strength_list << place.bundle_of_card[:field][0].strength
    end
    # puts("それぞれの強さは#{strength_list},最強は#{strength_list.max}") #for debug

    winner_index = strength_list.index(strength_list.max)
    puts "#{Place.all_place[winner_index].player.name}の勝ち"
    count = 0
    Place.all_place.each do |place|
      until place.bundle_of_card[:field].empty?
        Place.all_place[winner_index].bundle_of_card[:deposit] << place.bundle_of_card[:field].pop
        count += 1
      end
    end
    puts "#{Place.all_place[winner_index].player.name}はカードを#{count}枚もらいました．"
  end

  # ここまで　引き分けの処理がまだ

  def self.game_over?
    true
  end

  def self.display_ranking
  end
end
