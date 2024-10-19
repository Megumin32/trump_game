require_relative 'game'

Game.prepare_a_deck
Game.determine_players
# Game.determine_players_debug_mode # for debug
Game.deal_cards
Game.do_a_turn until Game.game_over == true
Game.display_ranking
