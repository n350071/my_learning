# RubyGoldに一発合格する

---

# インプット
* 教科書
  * はじめてRuby                ←数年前
  * オブジェクト脳の作り方       ←最近 ← ブロック, Procの説明はコレが１番わかりやすい
  * オブジェクト指向設計実践ガイド ←最近
  * Design Patterns in Ruby ←最近
  * Refactoring Ruby Edition ←最近
  * **Ruby技術者認定試験合格教本** ←試験対策そのものはコレをつかう
* 問題集
  * Ruby技術者認定試験合格教本
  * http://www.ruby.or.jp/ja/certification/examination/rex
    * 54%
* Extra
  * 関数型プログラミング
    * [可変性の回避 ― Rubyへの関数型プログラミングスタイルの適用](http://postd.cc/avoid-mutation-functional-style-in-ruby/)

# RubySilverの反省点
* 90点で合格
* 期間:2週間
* 反省点
  * 以下の対策が甘く、試験時に賭けをすることになった。キーワードは知っていたので、可能性がある部分について対策をしておくべきだった。
    * each_with_index
    * String#each_char
    * exit
  * もっと期間短縮できたと感じる
    * 時間をかけるべきところの濃淡の配分をもっと早く見つけられれば、やらなくてよいところまでやらなくて済む
      * すでにGoldの内容に一部踏み込んで勉強してしまっていた。
      * 一方で、Silverの対策が疎かになっていた部分があった
    * 濃淡が分かれば、やるべきところに時間をかけられる
    * 濃淡がわかるには、問題を先に解いて、↓の２点を重点対策しよう
      * ①間違えたところ
      * ②あやふやだと感じるところ

# 重点対策ポイント
## オブジェクト指向
* クラスと変数
  * クラスインスタンス変数 `@val`
    * 特異メソッドからアクセスできる
    * 特異クラスのクラスインスタンス変数 `@val`
    * 定数の探索経路(Q.44)
  * 特異クラス
  * クラス定義と、各変数の実行タイミング ←整理したい
* メソッド
  * クラスメソッド
  * インスタンスメソッド
  * 特異メソッド
* Mix-in
  * include
    * 複数モジュールを指定した場合は、左側が先
  * extend
  * メソッド探索
    * 特異クラス
  * load,require(外部ライブラリ読み込み)とinclude,extend(モジュール読み込み)の違い
* 継承
* オープンクラス
  * メソッド再定義、オーバーロード
  * どこで定義されたメソッドを再定義しようとしている？(Q.36)
  ```
  class Integer
  def +(other)
    self.-(other)
    end
  end

  p 1 + 1
  ```
* super
  * 引数ありなし
  * メソッド探索
* self
  * ```p [1,2,3,4].map(&self.method(:*))```
  * どのクラス・モジュールを指している？

## ブロック
* ブロックとメソッド、メソッドの引数
  * Kernel#block_givien?
  * yield
  * lambda
  * call
  * Proc
  * 引数 `|*args|` で渡された時 ←これはキーワード引数とか、多重代入？
  * {},do end
      * ```
        m1 m2 do
          "hello"
        end
        ```

## その他
* Ruby実行オプション
* 可視性(public,protect,private)
* attr_accessor, attr_reader, attr_writer(Q.43,Q.　50)
* キーワード引数
  * `**` Hash (`*`の場合はどうなる？)
  * コール、および受け側
* エイリアス
  * alias_method
  * Module#alias
* 演算子の優先順位
  * 短絡評価およびand,or、そしてシンタックスエラーの評価
    * ```true or raise RuntimeError```
    * ```false and raise RuntimeError```
* 範囲演算子の条件式の詳細
  * `d<2..d>5` と `d<2...d>5` の違い
* Comparable#between?
* Enumerable
* 例外(else構文)
* File#read

---

# 重点対策ポイント別のまとめ
## オブジェクト指向
## ブロックなど
### ブロック

種類 | 優先順位 | 渡される先
-- | --
`do ~ end` | | `yield`
`{}` | | `yield`

### ブロックを受ける
#### yield
* yield(x)でブロックに引数(x)を渡して実行する
* 関数を受け取れる関数

```
def arg_one
  yield(1) + yield(2)
end

p arg_one{|x| x + 3} #=> (3+1) + (3+2) #=> 9
```

#### &block
* ブロック引数を明示し、callメソッドで実行する
* 関数を受け取れる関数

```
def arg_one(&block)
  block.call(1) + block.call(2)
end

p arg_one{|x| x + 3} #=> 9
```
#### Procオブジェクト
* 関数をオブジェクトとして作成
* 引数の数のチェックがない

```
plus_three = Proc.new{|x| x + 3 }
p plus_three.call(1) + plus_three.call(2) #=> 9
```

#### lambda
* Procと違って、引数の数のチェックがある

```
plus_three = lambda{|x| x + 3}
p plus_three.call(1) + plus_three.call(2) #=> 9
```

### クロージャー

## その他
### Ruby実行オプション
### 可視性
### キーワード引数
### エイリアス
### 演算子の優先順位
### 範囲演算子の条件式
### Module
#### Comparable
#### Enumerable
#### 例外
#### FileなどIO

# 添付ライブラリ
## socket
## date
## stringio など
