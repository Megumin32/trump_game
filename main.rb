require_relative 'game'

# デッキを準備
Game.prepare_a_deck
# プレーヤーを決定
Game.determine_players
# Game.determine_players_debug_mode # for debug
# カードを配る
Game.deal_cards
# 誰かがゲームオーバーになるまで，ターンを繰り返す
Game.do_a_turn while Game.game_over == false
# 順位を表示する
Game.display_ranking
