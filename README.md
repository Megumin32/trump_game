# トランプゲームの戦争
## ファイルの説明
### main.rb 
ゲームの進行
### game.rb
ゲームの動作に関すること
### card.rb 
カードに関すること
### player.rb
プレイヤーに関すること
### place.rb
- 場所（手札，対戦する場，預かり場）に関すること
- インスタンスは2つの変数`player`,`bundle_of_card`を持つ
- `bundle_of_card`はハッシュ`{手札=> , 場=> , デポジット=> }`である．
#### メソッドについて
- self.hand_to_field：手札から場にカードを出す
- self.field_to_deposit：場にあるカードを勝者のデポジットに移動
- self.deposit_to_hand：デポジットから手札に加える
- self.count_the_number_of_hands：全員の手札のカード枚数を数える