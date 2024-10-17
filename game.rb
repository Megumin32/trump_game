require_relative 'card'
require_relative 'player'
require_relative 'place'

class Game
  @@game_over = false

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

  def self.determine_players_debug_mode # for debug
    Player.Generate_players('aida')
    Player.Generate_players('ishi')
    Player.Generate_players('ueda')
    Player.Generate_players('endo')
    Player.Generate_players('ohno')
    Player.group.each do |player|
      Place.new(player)
    end
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
    puts '戦争！'
    Place.hand_to_field
    winner = determine_the_winner
    Place.field_to_deposit(winner)
    Place.deposit_to_hand
    game_over?

    # ########################################### for debug
    # temp = []
    # Place.all_place.each do |place|
    #   temp << place.bundle_of_card[:hand].length
    # end
    # puts "残りの手札は#{temp}"
    # ###########################################
  end

  def self.determine_the_winner
    strength_list = []
    Place.all_place.each do |place|
      strength_list << place.bundle_of_card[:field][-1].strength
    end
    # puts("それぞれの強さは#{strength_list},最強は#{strength_list.max}") #for debug

    if strength_list.count(strength_list.max) == 1
      winner_index = strength_list.index(strength_list.max)
      puts "#{Place.all_place[winner_index].player.name}の勝ち"
      winner_index
    else
      puts '引き分けです'
      nil
    end
  end

  def self.game_over
    @@game_over
  end

  def self.game_over?
    Place.all_place.each do |place|
      if place.bundle_of_card[:hand].empty?
        puts "#{place.player.name}の手札がなくなりました"
        @@game_over = true
      end
    end
  end

  def self.display_ranking
    ranking_count = 1
    points = Place.count_the_number_of_cards
    points.length.times do
      max_index = points.index(points.max)
      print "#{ranking_count}位 => #{Player.group[max_index].name}\n"
      points[max_index] = -1
      ranking_count += 1 if points.count(max_index) == 0
    end
  end
end
