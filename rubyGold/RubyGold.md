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

* ブロックは、メソッドコールの時にのみ書ける
  * `func(1){p 'Here is block'}`
* 新たにスコープを作成する
  * ブロック内で初期化した変数は、ブロック終了と共に消滅する(外部から参照できない)
    * `func(1){x+=2}; p x #=> NameError`
  * ブロック外の変数をブロック内で評価・更新が可能
    * `x=2; func(1){x+=2}; p x #=> 4`
    * {}ブロックの中に、xも閉じ込める(クロージャー)している
      * クロージャーとは生成時の環境を閉じ込める仕組みを一般的に指す言葉
* ブロックの定義
  * `{}` or `do end`
  * 引数
    * 仮引数 `||` で指定
    * 実引数 `yield`で指定
      * ```
        def func a,b
          a + yield(b,3)
        end
        p func(1,2){|x,y| x+y} #=>6
        ```
* block_given?
  * ブロックが指定されたかどうかで処理を分けることができる
  * ```
    def func
      return 1 if block_given?
      2
    end
    p func(){} #=>1
    p func     #=>2
    ```
* Proc
  * ローカル変数に紐付けられたブロックのオブジェクト
  * ブロックは
    * コンストラクタで渡す
    * 実行時に渡す
  * 例
    * ```
      def gen_times(factor)
        return Proc.new {|n| n*factor }
      end

      times3 = gen_times(3)
      times5 = gen_times(5)

      times3.call(12)               #=> 36
      times5.call(5)                #=> 25
      times3.call(times5.call(4))   #=> 60
    ```
  * call
    * blockを呼び出す
    * `.()`と`.`は`call`のシンタックスシュガー
    * 引数の数が足りなければ、nilを代入するのでエラーにならない
    * 引数の数が多ければ、無視する
* Procとブロックの相互変換
  * Proc→ブロック
    * &をつけて引数の最後に指定する
      * `proc=Proc.new{2}; func(1,&proc)`
  * ブロック→Proc
    * 最後の仮引数に&を付けた名前を指定する
    * 参照時は&を外す
      * `def func x, &proc; x + proc.call; end`
    * ブロック中のリターン
      * 生成元のスコープを脱出する
        * トップレベルで生成したブロックであれば、脱出先がないのでエラー
        * メソッド中で生成したブロックであれば、メソッドを抜ける
* Kernel#lambda{|...| block} -> a_proc
  * Equivalent to Proc.new, except the resulting Proc objects check the number of parameters passed when called.
    * →引数の数をチェックすることを除いて、Proc.newと同じ
  * 定義方法
    * `lmd = lambda{|x| p x}; lmd.call(1) #=>1`
    * `lmd = -> (x){p x}; lmd.call(1) #=>1`
  * ブロック中のリターン
    * 呼び出し元に戻る
* 自分で定義したクラスに、ブロックを受けるeachメソッドを定義する
  * ```
  class Result
    include Enumerable

    def initialize
        @results_array = []
    end

    def <<(val)
        @results_array << val
    end

    def each(&block)
        @results_array.each(&block)
    end
  end
  ---
  r = Result.new  
  r << 1
  r << 2
  r.each { |v|
    p v
  }
  #print:
  # 1
  # 2
  ```

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
#### 例外、大域脱出
#### FileなどIO

# 添付ライブラリ
## socket
## date
## stringio など
