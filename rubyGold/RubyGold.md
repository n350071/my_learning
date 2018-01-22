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
    * [「関数型Ruby」という病](http://yuroyoro.hatenablog.com/entry/2012/08/08/201720)

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
* 継承
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

### super
  * super
    * メソッドが受け取った引数をそのままスーパークラスに渡す
  * super()
    * メソッドが受け取った引数を渡さない

### 継承チェーン
  * Object < Kernel < BasicObject
  * ancestors
  * instance_methods(false) #スーパークラスを辿らない
  * エイリアス
    * メソッドではないので、`,`は不要
    * メソッド名は識別子かシンボルで指定(文字列は不可)
      * `alias new_method_name old_method_name`
      * `alias new_global_name old_global_name`
    * 定義前に書くとNameError
  * 定義取り消し
    * undef <メソッド名>,<メソッド名>,<メソッド名>
    * 定義前に書くとNameError
  * 例
    * ```
      class Hoge
        def huga1; end
        def huga2; end
        alias :huga3 :huga1
        alias :huga4 :huga2
        undef :huga2
      end

      p Hoge.instance_methods(false)
      #=> [:huga1,:huga3, :huga4]
      ```
### オープンクラス
* スーパークラスを指定してオープンする場合は、別のスーパクラスは定義できない

```
class Foo; end
class Bar; end
class Baz < Foo
end
class Baz < Bar #TypeError
end
class Baz < Foo #ok
end
class Baz #ok
end
```

### [Mix-in](./mix_in_sprc.rb)

### メソッドの可視性

識別子 | 可視性
-- | --
public  | any instance
protected | self or instance of subclass
private | self(レシーバ付呼出不可)

* 可視性はサブクラスで変更可能
* メソッド名をシンボルで指定することも可能
  * `private :method1, :method2`

### 変数と定数
#### ローカル変数
```
v1 = 1
class Scope
  v2 = 2
  def getV1
    v1        #クラス外の変数
  end
  def getV2
    v2        #クラス定義とインスタンスメソッドはそれぞれ独立したスコープを持つ
  end
end

s = Scope.new
s.getV1 #=> NameError
s.getV2 #=> NameError
```

#### インスタンス変数
未初期化→nil
```
@v1 = 1
class Scope
  @v2 = 2
  def method1
    @v1
  end
  def method2
    @v2
  end
  def v3　#メソッドで定義しているので、サブクラスからも参照できる
    @v3
  end
  def v3=(val)
    @v3=val
  end
  attr_accessor :v4 #メソッドで定義しているので、サブクラスからも参照できる
end

s = Scope.new
p s.method1 #=> nil
p s.method2 #=> nil
s.v3=3
s.v4=4
p s.v3 #=>3
p s.v4 #=>4
```

#### クラス変数
サブクラスで同名のクラス変数を定義した場合、それは代入であり、上位クラスのクラス変数の値変更にほかならないことに注意。

#### 定数
* 再代入
  * 可能
  * 警告が出る
* メソッド内
  * 定義不可
  * 再代入不可
* :: (二重コロン記法)
  * ```
    class Foo; end
    class Bar; end

    Foo::Con      = 1 #=>FooクラスにCon定数
    Foo::Con::Con = 2 #=>TypeError: 1 is not a class/module

    Foo::Bar      = Bar
    Foo::Bar::Con = 3 #=>FooクラスのBarクラスにCon定数を定義
    ::Foo::Bar

    Foo.constants          #=> [:Con,:Bar]
    Bar.constants          #=> [:Con]
    Foo::Con == ::Foo::Con #=> true(ルートから参照)
    ```
* 探索
  * ネストの内側に見つからなければ、ネストの外側に向かって探索する
    * つまり、親やモジュールで宣言された定数はサブクラスやincludeしたクラスから参照できる
  * ```
    class Foo; A=1; end
    module Bar; B=2; end
    class FooExt < Foo
      include Bar
      p A #=>1
      p B #=>2
      p C #=>NameError: uninitialized constant FooExt::C
    end
    class FooConstMissiing
      def self.const_missing(id) #クラスメソッドとして定義すること！(インスタンスメソッドだとNameError)
        3
      end
    end
    FooConstMissiing::D #=>3
    ```


## [ブロック](./block_spec.rb)
### Block, Proc, lambda
* ブロックは、メソッドコールの時にのみ書ける
  * `func(1){p 'Here is block'}`
* ブロックは、新たにスコープを作成する
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
  * Proc#call
    * blockを呼び出す
    * `.()`と`.`は`call`のシンタックスシュガー
    * callの引数は、ブロックの引数になる
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

### スレッド

* Thread initialization
  * ::new
    * `{...}` -> thread
    * `::new(*args,&proc)` -> thread
    * `new(*args){|args|...}` -> thread
  * ::start
    * `([args]*){|args|block}` -> thread
  * ::fork
    * `([args]*){|args|block}` -> thread
* Thread termination
  * #kill(thread)
* scope
  * same as block
* Any threads not joined will be killed when the main program exits.
  * `thread.join`

```
t = Thread.new do  #スレッド生成、Thread.new,Thread.start,Thread.fork
  p "thread start"
  sleep 5 # 5sec
  p "thread end"
end
p "wait"
t.join # スレッドの終了を待ってから抜ける
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
##### 脱出構文(loopから抜ける)

 メソッド | 説明 | 例(現在5回目のループ)
-- | -- | --
| break | ループを中断 | ループを抜ける
| next | 中断して次のループに進む | 6回目のループに入る
| redo | 現在のループを繰り返す | 5回目のループをもう一度

##### 例外処理
例外クラスの継承関係
* Exception
  * SignalException
  * ScriptError
    * SyntaxError
  * StandardError
      * ArgumentError
      * RuntimeError
      * ZeroDivisionError
      * NameError
        * NoMethodError

例外オブジェクトのメソッド
* message
* backtrace
* rase (最後に発生した例外をもう一度投げる..呼び出し元に委ねる)


##### 大域脱出(throw, catch)

* Kernel#throw :label, obj
  * 対応するラベルが見つからない場合は、 `UncaughtThrowError`
  * ラベルと一緒にオブジェクトを渡せる
* Kernel#catch([tag]){|tag|block} -> obj
  * catch executes its block.
    * if throw is not called, the block executes normally, and catch returns the value of the last expression evaluated.
    * if throw is called, the block stops executing and return val(or nil if no second argument was given to throw)
    * tag is much by object_id


```
def example
  catch(:a) do
    catch(:b) do
      puts ':b This puts is displayed'
      throw(:a, 123)
      puts ':b This puts is NOT displayed'
    end
    puts ':a This puts is NOT displayed'
  end
end

p example

def example
  catch(:a) do
    catch(:b) do
      throw(:b, 123)
      puts ':b This puts is NOT displayed'
    end
    puts ':a This puts is displayed'
  end
end

p example

```

#### FileなどIO

# 添付ライブラリ
## socket
## date
## stringio など
