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
    * 1回目:64%
    * 2回目:94%
  * http://www.ruby.or.jp/ja/certification/examination/rex
    * 1回目:54% ←Silve受ける前にやってみた
    * 2回目:76%
    * 3回目:84%
    * 4回目:86% <- 新規の問題が4問あり、8%落とした。
    * マラソン:24問連続正解
  * [ITトレメ](http://jibun.atmarkit.co.jp/scenter/ittrain/121_cal.html)
    * 1回目:91%
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



# 対策ポイント再整理
## 環境周り
### 実行時オプション
* -c 文法的に正しいかのcheck
* -e 文字列をRubyとしてexecute
* -w 冗長モードでwarningが出る
* -W0, -W1, -W2(= -W) 出力範囲を指定したWarning
* -l $LOAD_PATHに文字列追加
* -r 実行前にrequire(実行する)
* -d debugモード

### require, load
クラス |  メソッド   | 同一ファイル | 拡張子
 -- | -- | -- | --
Kernel# | require | １度だけ実行 | 省略可能
Kernel# | load    | なんども実行 | 省略不可能

### 組み込み定数
* STDIN
* STDOUT
* STDERR
* ENV 環境変数
* ARGF 仮想ファイル
* ARGV 引数
* DATA `__END__`行こうをアクセルするFileオブジェクト

### 環境変数
* RUBYOPT デフォルトで指定するコマンドラインオプション
* RUBYLIB デフォルトでライブラリを検索するパスを指定
* PATH Ruby上から実行したコマンドを検索するパスを指定

## オブジェクト指向

### [self](./self_spec.rb)

位置 | 参照オブジェクト
-- | --
モジュール内 | そのモジュール
クラス内 | そのクラス(newしたクラス?)
クラスメソッド | レシーバ(=呼んでいるクラス, 定義しているクラスではない!!)
インスタンスメソッド | レシーバ
ブロック内 | 呼び出したオブジェクト
トップレベル | Object(トップレベルはObjectクラス)

注意
```
問題のselfはObjectクラスのインスタンスになります。
Objectクラスには*メソッドが定義されていないためエラーになります。
p [1,2,3,4].map(&self.method(:*))
```

### [super](./super_spec.rb)

メソッド | 説明
-- | --
`super` | 引数をそのままスーパークラスへ渡す
`super()` | 引数をスーパークラスへ渡さない
`initialize(*)` | 無名の多重代入

* 無名の多重代入
  * 引数が多い場合→問題なく省く
  * 引数が足りない場合→値がわからなくてエラーになる

### public, protected, private
* public
  * どこからでもレシーバをつけて呼べる
  * デフォルト
* protected
  * 自身
  * サブクラスのインスタンス
* private
  * 自身
  * レシーバは付加禁止
  * 要注意のメソッド
    * initialize
    * トップレベルで定義されたメソッド
* その他
  * 可視性はサブクラスでオーバーライド可能
  * メソッド名をシンボルで指定することも可能
    * ```
      public  :xxx, :yyy
      private :aaa, :bbb
      ```

### オープンクラス
クラスを再定義する。
```
class Foo; end
class Bar < Foo; end # < は継承の意味。<<と混同して混乱しないように!

class Bar ; end      #ok:親を省略してもFooを引き継いだまま
class Bar < XXX; end #TypeError:親はFooであり変更できない
```

### [エイリアスとundef](./alias-undef_spec.rb)
* エイリアス式
  * 対象
    * メソッド
    * グローバル変数
  * Syntax
    * メソッド名は識別子(そのまま)かシンボルで指定(文字列は不可)
    * 定義前に書くとNameError
* Module#alias_method
  * `alias_method :orig_exit, :exit`
* undef
  * undef <メソッド名>,<メソッド名>,<メソッド名>
  * 定義前に書くとNameError
  * undefすると、継承・includeしたものすべて、そのクラスから完全に取り除く。親には影響しないが、そのクラスの全インスタンスから消える

**undef_method**
**remove_method**


### [Mix-in](./mix-in_spec.rb)

* include
  * クラスにモジュールのインスタンスメソッドを追加する
* prepend
  * クラスにモジュールのインスタンスメソッドを追加する(そのオブジェクト自身のメソッドに優先して探索される)
* extend
  * オブジェクトにモジュールのインスタンスメソッドを追加する
* `class <<`
  * オブジェクトのシングルトンクラスにアクセスする
  * `class << M` モジュールMに対して行えば、モジュールの特異クラスにアクセスする
  * [公式リファレンス](https://ruby-doc.org/core-2.5.0/doc/syntax/modules_and_classes_rdoc.html#label-Singleton+Classes)
* method中で定義されるメソッド
  * 外側のメソッドが呼ばれるまで定義されない
* Refinements
  * module <モジュール>; refine <クラス> do ~ end; end : ターゲットとするクラスと、変更内容を書く
  * using <モジュール> : 変更実施()
  * クラスメソッドを再定義するときは<クラス>.singleton_class do とする(ブロック内でself.methodとしない。)
* 追加
  * class_eval
  * module_eval
  * instance_eval
  * 文字列を渡す(レシーバのスコープで評価される)
  * ブロックを渡す(スコープはそのまま。レシーバとは関係なし)


### [変数と定数](./valiable_spec.rb)
#### ローカル変数
#### インスタンス変数
#### クラス変数
サブクラスで同名のクラス変数を定義した場合、それは代入であり、上位クラスのクラス変数の値変更にほかならないことに注意。

#### 定数
* 警告が出るが、再代入可能
* メソッド内では定義も再代入もSyntaxError
* :: (二重コロン記法)
* 探索


## [ブロック](./block_spec.rb)
### Block, Proc, lambda
* block_given?
* {}とdo endの結合度
  * {}は()をつけないと引数より先に計算
  * do-endは()をつけてもつけなくても一緒
* Proc
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

### スレッド
* スレッドの生成
  * Thread.new(x){|x| x+1}
  * Thread.start(x){|x| x+1}
  * Thread.fork(x){|x| x+1}
* スレッドの状態
  * run 実行中or実行可能状態
  * sleep 一時停止状態
  * aborting 終了処理中
  * false 正常終了
  * nil 例外など異常終了
* 状態確認
  * status
  * alive?
  * Thread.list スレッドの一覧を配列で取得
  * Thread.main メインスレッド取得
  * Thread.current 現在のスレッド取得
  * Thread.pass 実行中の状態を変えずに他のスレッドに実行権を譲る
* 即実行する
  * run
* 実行可能状態にする
  * wakeup
* 一時停止
  * sleep
  * joinで待っている時
  * Thread.stop
* 終了
  * kill
  * exit
  * Thread.kill
  * Thread.exit
  * ensure節
    * 正常終了処理(kill/exit)
  * rescue節
    * 例外時処理
  * rescue節がない場合
    * 警告なしで終了
    * joinで待っているスレッドがあればそちらへ波及
* 優先度
  * priority
  * priority=(Fixnum)
* スレッド内のデータ
  * t = Thread.current
  * t[:foo]="bar"
  * t.key?(:foo) #=> true
  * t.keys       #=> [:foo]

### Fiber
* 生成
  * f = Fiber.new
* 実行する
  * f.resume
* 実行権限を戻す
  * Fiber.yield


### Regexp
* オプション
  * i, Regexp::IGNORECASE 1
  * x, Regexp::EXTENDED   2
  * m, Regexp::MULTILINE  4
* マッチング
  * match -> MatchData / nil
  * =~ -> index / nil
  * === -> true / false
  * ~ Regexp.new("abc") -> index / nil (最後にget,readlineした値が入る特殊変数と突き合わせる`$_`)
* 正規表現の生成
  * /abc/
  * Regexp.new("abc")
  * Regexp.compile("abc")
  * Regexp.escape("abc.()[]")
  * Regexp.quote("abc.()[]")
* マッチした結果の取得
  * last_match -> MatchData
    * `$~`
    * last_match(0)
  * last_match(1)
    * $1
  * last_match(2)
    * $2
* 正規表現の論理和
  * Regexp.union(/abc/,/ABC/) -> abc,ABCのどちらかにマッチする正規表現
* 正規表現オブジェクトのオプションや属性の取得
  * options   -> 指定したオプションの論理和
  * casefold? -> Regexp::IGNORECASEが指定されているか？
  * encoding  -> #<Encoding:UTF-8>
  * souce     例(/a/.source   #=> "a")
  * inspect   例(/a/.inspect  #=> "/a/")
  * to_s      例(/a/.to_s     #=> "(?-mix:a)")

### マーシャル
* 概要
  * オブジェクトを文字列化する
  * セッション変数やクッキーをDBに保存するときなどに使う
  * 書き出せないクラス
    * IO,File,Dir,Socket
    * 特異メソッドを定義したオブジェクト
    * 無名クラス、モジュール
  * 書き出すオブジェクトに制限
* オブジェクトを文字列化する書き込む
  * Marshal.dump({:a=>1,:b=>2,:c=>3},file)
  * str = Marshal.dump({:a=>1,:b=>2,:c=>3})
* 復元する
  * Marshal.load(file)
  * Marshal.load(str)


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

x, *y = *[0,1,2] #=>  x=0, y=[1,2] #右辺の*は無視してよい
(a,b),c = [1,2,3,4],5
#=> a=1
#=> b=2
#=> c=5

#無名の可変長引数
def initialize(*) #サブクラスでsuperとしてエラーにならないので、意識しなくてよくなる
end
```

### Date,Time,DateTime
```
require 'date'
(Time.now - Time.new).class       #=>	Float
(Date.today - Date.new).class     #=> Rational
(DateTime.now - Date.today).class #=> Rational
Time.now - DateTime.now           #=> ConvertError
```

### キーワード引数
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

* 仮引数に`**`をつけておくと、ハッシュを期待する

```
＜例１＞
def foo(z)
  z                 
end
foo(c:100,d:200)    #=>{:c=>100, :d=>200}
foo({c:100,d:200})  #=>{:c=>100, :d=>200}
foo 1               #=>1

def bar(**z)
  z                 # *z,**z はSyntaxError
end
bar(c:100,d:200)    #=>{:c=>100, :d=>200}
bar({c:100,d:200})  #=>{:c=>100, :d=>200}
bar 1               #=>ArgumentError: wrong number of arguments
```


### 演算子の優先順位
* 短絡評価およびand,or、そしてシンタックスエラーの評価
  * ```true or raise RuntimeError```
  * ```false and raise RuntimeError```
### 範囲演算子の条件式
* [範囲演算子の条件式の詳細](https://docs.ruby-lang.org/ja/2.1.0/doc/spec=2foperator.html#range)
  * `d<2..d>5`
    * d=0のときd<2だけを見てtrueを返し、d>5がtrueであればd<2を計算するが、d>2がfalseなのですぐにd>5になるまでtrueを返し続け、d>5になったタイミングでfalseを返して、またd<2だけを見るようになる
  * `d<2...d>5`
    * d=0のときd<2だけを見てtrueを返し、d>5になるまでtrueを返し続け、d>5になったタイミングでfalseを返して、またd<2だけを見るようになる  
### Module
[RubySilverを参照](../rubySilver/RubySilver.md)

### 脱出・例外
#### 脱出構文(loopから抜ける)

 メソッド | 説明 | 例(現在5回目のループ)
-- | -- | --
| break | ループを中断 | ループを抜ける
| next | 中断して次のループに進む | 6回目のループに入る
| redo | 現在のループを繰り返す | 5回目のループをもう一度

#### 例外処理
[例外クラスの継承関係](./error_spec.rb)

例外オブジェクトのメソッド
* new / exeption
* message
* to_s
* to_str
* backtrace
* rase (最後に発生した例外をもう一度投げる..呼び出し元に委ねる)

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

### freeze, taint, clone, duplicate
#### Object#freeze
* Prevents further modifications to obj.
  * 破壊的な操作が不可
    * ```
      hoge = "hoge".freeze
      hoge.upcase!          #=> RuntimeError
      ```
  * 代入はできる
    * ```
      hoge = "hoge".freeze
      hoge = "foo"          #=> "foo"
      ```
* There is no way to unfreeze a frozen object.
  * frozen?で確認することはできる
    * ```
      hoge = "hoge".freeze
      hoge.frozen?          #=> true
      ```
* モジュールもfreeze可能

#### 汚染
* taint
  * Objects that are marked as tainted will be restricted from various built-in methods.
* untaint
  * remove the mark
* tainted?

#### 複製

method | taint | object_id  | 要素のobject_id  | 特異メソッド   | frozen?
--     | --    | --         | --              | --           | --    
clone  | copy  | 異なる      | 同じ             | コピーする    | コピーする  
dup    | copy  | 異なる      | 同じ             |             |       
