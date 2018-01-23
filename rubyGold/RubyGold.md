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
    * 1回目:54%
    * 2回目:76%
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

---

# 重点対策ポイント別のまとめ
## オブジェクト指向

### super
  * super
    * メソッドが受け取った引数をそのままスーパークラスに渡す
      * スーパークラスでは`initialize(*)`というように無名オブジェクトの多重代入にしておくと、下位クラスで()をつけるかどうかを意識しなくて済む
  * super()
    * メソッドが受け取った引数を渡さない

### 継承チェーン
  * Object < Kernel < BasicObject
  * ancestors
  * instance_methods(false) #スーパークラスを辿らない
  * エイリアス
    * Syntax
      * メソッドではないので、`,`は不要
      * メソッド名は識別子かシンボルで指定(文字列は不可)
        * `alias new_method_name old_method_name`
        * `alias new_global_name old_global_name`
      * 定義前に書くとNameError
    * Module#alias_method
      * `alias_method :orig_exit, :exit`
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

```
class Foo; end
class Bar; end
class Baz < Foo
end
class Baz < Bar #TypeError スーパークラスを指定してオープンする場合は、別のスーパクラスは定義できない
end
class Baz < Foo #ok
end
class Baz #ok
end
```

### [Mix-in](./mix_in_sprc.rb)

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
* 中身の直接変更
  * 可能
  * 警告なし
  * `CONST[0] = "A" #=> ["A",2,3]`
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
    * Procを格納した変数名と同名のメソッドがあっても、この変数名の方が優先されて呼ばれる
      * ```
        def proc(x); p "func #{x}"; end
        proc = Proc.new{|x|p "proc #{x}"}
        proc.call(2)   #=> "proc 2"
        proc[2]        #=> "proc 2"
        proc.(2)       #=> "proc 2"
        proc.yield(2)  #=> "proc 2"
        proc(2)        #=> "func 2"
        proc 2         #=> "func 2"
        ```
    * シンタックスシュガー `proc = Proc.new{|times, *args| args.map{|val| val * times}}`
      * `proc.call(9,1,2,3)   #=>[9,18,27]`
      * `proc[9,1,2,3]        #=>[9,18,27]`
      * `proc.(9,1,2,3)       #=>[9,18,27]`
      * `proc.yield(9,1,2,3)  #=>[9,18,27]`
    * callの引数は、ブロックの引数になる
      * 引数の数が足りなければ、nilを代入するのでエラーにならない
      * 引数の数が多ければ、無視する
  * Proc#arity
    * 引数の数を取得
  * next
    * 手続きオブジェクト内で処理を中断し、呼び出し元へ最後の評価値を返す
    * ```
      f = Proc.new{next 'next'; 'last'}
      f.call #=> 'next'
      ```
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
  * ブロック中に呼び出し元に戻る
    * return
    * break
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
  * {}とdo endの結合度
    ```
    def m1(*)
      str = yield if block_given?
      p "m1 #{str}"
    end

    def m2(*)
      str = yield if block_given?
      p "m2 #{str}"
    end

    m1 m2 {
      "hello"
    }
    #=> m2 hello
    #=> m1

    m1 m2 do
      "hello"
    end
    #=> m2
    #=> m1 hello

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
### 多重代入
受け取ったあと`*`をつけると配列から展開。つけないと配列のまま
```
def foo *a
  p *a
end
foo(1,2)
#=> 1
#=> 2

def bar *b
  p b
end
bar(1,2)
#=>[1,2]
```

無名の可変長引数
```
def initialize(*) #サブクラスでsuperとしてエラーにならないので、意識しなくてよくなる
end
```

### Date,Time,DateTime

演算 | 戻り値クラス
Time同士の減算 |	Float
Date同士の減算 | Rational
DateTime同士の減算 |	Rational
DateTime.now-Date.today | Rational
Time.now - DateTime.now など | convertエラー

### キーワード引数
* 引数名:デフォルト値

```
def foo(a:, b: 100)
 a + b
end
foo(a:2,b:3)      #=> 5
foo(**{a:2,b:3})  #=> 5 ハッシュを渡すときは、**をつける
foo(a: 1)         #=> 101
foo               #=>ArgumentError aはデフォルト値がないため
foo(a:2,b:3,c:4)  #=>ArgumentError cなんてない
foo(3,3)          #=>ArgumentError: wrong number of arguments
```

* 仮引数に`**`をつけておくと、ハッシュを受け取れる

```
＜例１＞
def bar(**z)
  z                 # *z,**z はSyntaxError
end
bar(c:100,d:200)    #=>{:c=>100, :d=>200}
bar({c:100,d:200})  #=>bar({c:100,d:200})

＜例２＞

```


### self

位置 | 参照オブジェクト
-- | --
クラス内 | newしたクラス
メソッド内 | レシーバ
ブロック内 |

```
問題のselfはObjectクラスのインスタンスになります。
Objectクラスには*メソッドが定義されていないためエラーになります。
p [1,2,3,4].map(&self.method(:*))

class Foo
  def foo
    ary = [1,2,3,4]
    ary.map(&self.method(:*))
  end
end
Foo.new.foo #=>NameError: undefined method `*' for class `Foo'

class Bar
  def *(input)
    input * input
  end
  def bar
    ary = [1,2,3,4]
    ary.map(&self.method(:*))
  end
end
Bar.new.bar  #=>[1,4,9,16]
```

### 演算子の優先順位
* 短絡評価およびand,or、そしてシンタックスエラーの評価
  * ```true or raise RuntimeError```
  * ```false and raise RuntimeError```
### 範囲演算子の条件式
* 範囲演算子の条件式の詳細
  * `d<2..d>5` と `d<2...d>5` の違い
### Module
#### Comparable
* Comparable#between?
#### Enumerable

### メソッドの可視性

識別子 | 可視性
-- | --
public  | any instance
protected | self or instance of subclass
private | self(レシーバ付呼出不可)

* 可視性はサブクラスで変更可能
* メソッド名をシンボルで指定することも可能
  * `private :method1, :method2`
* initializeは常にprivate


### 脱出・例外
#### 脱出構文(loopから抜ける)

 メソッド | 説明 | 例(現在5回目のループ)
-- | -- | --
| break | ループを中断 | ループを抜ける
| next | 中断して次のループに進む | 6回目のループに入る
| redo | 現在のループを繰り返す | 5回目のループをもう一度

#### 例外処理
例外クラスの継承関係
* Exception
  * SignalException
  * ScriptError
    * SyntaxError
  * StandardError
      * ArgumentError
      * RuntimeError *デフォルト*
      * ZeroDivisionError
      * NameError
        * NoMethodError

例外オブジェクトのメソッド
* message
* backtrace
* rase (最後に発生した例外をもう一度投げる..呼び出し元に委ねる)

```
def ex
  begin
    raise
  rescue => e
    e.backtrace
  end
end
ex #=>["(irb):17:in `ex'", "(irb):22:in `irb_binding'", "/System/Library/Frameworks/Ruby.framew...
...irb.rb:394:in `start'", "/usr/bin/irb:11:in `<main>'"]
```


#### 大域脱出(throw, catch)

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

### freeze
freezeはオブジェクトを凍結します。凍結されたオブジェクトは次の特徴があります。

* 破壊的な操作ができません。
* オブジェクトの代入ができます。
* 自作クラスのインスタンス変数をfreezeしない限り、変更できます。

```
# 破壊的操作ができない例
hoge = "hoge".freeze
hoge.upcase!
p hoge

# <実行結果>
# RuntimeError: can't modify frozen String

# オブジェクトの代入ができる例
hoge = "hoge".freeze
hoge = "foo".freeze
p hoge

# <実行結果>
# foo
```


#### FileなどIO

# 添付ライブラリ
## socket
## date
## stringio など


---
３回目
* CONSTをfreezeして変更する 1
* `p [1,2,3,4].map(&self.method(:*))` 20
* 30
* 41なんで？
