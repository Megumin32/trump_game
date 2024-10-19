# トランプゲームの戦争 
## ファイルの説明
### main.rb（ゲームの進行）
### card.rb（カード）
### player.rb（プレイヤー）
### game.rb（ゲームの動作）
クラス変数
- @@game_over: 手札が0枚になった人がでたとき`true`になる
  
クラスメソッド
- prepare_a_deck: デッキを準備する
- determin_players: プレーヤーを生成する
- deal_cards: カードをデッキからプレーヤーに配る
- do_a_turn: 1つのターンの処理
- game_over: クラス変数`@@game_over`にアクセスするためのメソッド
- display_ranking: 順位を計算し表示する
### place.rb（カードが存在する場所）
- インスタンスは2つの変数`player`,`bundle_of_card`を持つ
- `bundle_of_card`はハッシュ`{手札=> , 場=> , デポジット=> }`である．
クラスメソッド
- hand_to_field: 手札から場にカードを出す
- field_to_deposit: 場にあるカードを勝者のデポジットに移動
- deposit_to_hand: デポジットから手札に加える
- count_the_number_of_hands: 全員の手札のカード枚数を数える