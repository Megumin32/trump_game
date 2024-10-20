require_relative 'card'
require_relative 'player'
require_relative 'place'

class Game
  @@game_over = false

  def self.prepare_a_deck
    Card.generate_cards
    Card.make_a_deck
  end

  def self.determine_players
    begin
      puts 'プレーヤーの人数を入力してください．（2〜5）'
      num = gets.to_i
      num = 0 if num < 2 || num > 5
      1 / num
    rescue ZeroDivisionError
      puts 'エラー： 有効な数値ではありません．2〜5を入力してください．'
      retry
    end

    num.times do |i|
      puts "プレーヤー#{i + 1}の名前を入力してください．"
      Player.Generate_players(gets.chomp.to_s)
    end

    Player.group.each do |player|
      Place.new(player)
    end
  end

  def self.determine_players_debug_mode # for debug
    Player.Generate_players('プレーヤー1')
    Player.Generate_players('プレーヤー2')
    Player.Generate_players('プレーヤー3')
    Player.Generate_players('プレーヤー4')
    Player.Generate_players('プレーヤー5')
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
  end

  def self.do_a_turn
    puts '戦争！'
    Place.hand_to_field
    winner = determine_the_winner
    Place.field_to_stock(winner)
    Place.stock_to_hand
    game_over_judge
  end

  def self.determine_the_winner
    strength_list = []
    Place.all_place.each do |place|
      strength_list << place.bundle_of_card[:field][-1].strength
    end
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

  def self.game_over_judge
    Place.all_place.each do |place|
      if place.bundle_of_card[:hand].empty?
        puts "#{place.player.name}の手札がなくなりました"
        @@game_over = true
      end
    end
  end

  def self.display_ranking
    duplication_count = 0
    points = Place.count_the_number_of_hands
    for i in 1..points.length do
      max_index = points.index(points.max)
      print "#{i + duplication_count}位 => #{Player.group[max_index].name}, 手札は#{Place.all_place[max_index].bundle_of_card[:hand].length}枚\n"
      if points.count(points[max_index]) == 1
        duplication_count = 0
      else
        duplication_count -= 1
      end
      points[max_index] = -1
    end
  end
end
