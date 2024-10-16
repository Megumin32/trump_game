require_relative 'game'

# デッキを準備
Game.prepare_a_deck
# プレーヤーを決定
Game.determine_players
# カードを配る
Game.deal_cards
# 誰かがゲームオーバーになるまで，ターンを繰り返す
Game.do_a_turn # until Game.game_over?
# 順位を表示する
Game.display_ranking
