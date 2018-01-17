# RubySilverの試験範囲の知識を体系化して記憶を定着させる

---

# インプット
* 教科書
  * はじめてRuby                ←数年前
  * オブジェクト指向設計実践ガイド ←最近
  * Design Patterns in Ruby ←最近
  * Refactoring Ruby Edition ←最近
  * **Ruby技術者認定試験合格教本** ←試験対策そのものはコレをつかう
* 問題集
  * Ruby技術者認定試験合格教本 <- 92%
  * http://www.ruby.or.jp/ja/certification/examination/rex ← 94%
  * https://gist.github.com/sean2121/945035ef2341f0c39bf40762cd8531e0 <- 82%

# アウトプット
* 90点で合格
* 期間:2週間
* その他
  * 以下の対策が甘く、試験時に賭けをすることになった。キーワードは知っていたので、可能性がある部分について対策をしておくべきだった。
  * each_with_index
  * String#each_char
  * exit

---

# 文法

## 予約語
* 論理
  * nil
  * true
  * false
  * not
  * or
  * and
* 初期化ルーチン
  * BEGIN
  * END
* 例外
  * begin
  * end
  * rescue
  * retry
  * ensure
* クラス・メソッド・モジュール・ブロックなど
  * class
  * module
  * def
  * undef
  * super
  * yield
  * do
  * defined?
  * alias
  * self
* ループ
  * return
  * while
  * until
  * for
  * break
  * next
  * redo
* 制御構文
  * case
  * when
  * if
  * then
  * unless
  * else
  * elsif
* 特殊変数
  * `__LINE__`
  * `__FILE__`
  * `__ENCODING__`

## マジックコメント
* 行頭のコメントであり、エンコーディングを伝える。
* Ruby2.0以降はデフォルトUTF-8なので明示的に書く必要なし
* 書式
  * `/coding[:=]¥s*[¥w.-]+/` にマッチする形式
  * 'coding: ' or 'coding= '(スペースは0以上) + '`_`か英数字の文字列' or '-' の1文字以上の繰り返し
* 例
  * `# encoding: euc-jp`
  * `# -*- coding: euc-jp -*-`
  * `# vim:set fileencoding=euc-jp:`

## 変数/定数とスコープ

変数 | 命名規則 | スコープ | 未初期化
-- | -- | -- | -- |
ローカル | `[a-z or _][¥w]*` | 代入式〜ブロックorメソッド内 | nil : 代入未実行(`val = 1 if false`) <br> `NameError` : 未定義
インスタンス | `@¥w+` | インスタンス内 | nil
クラス | `@@¥w+` | クラスの全インスタンス内 | 例外
定数 | `[A-Z][¥w]*` | クラス・モジュール内 | 例外
グローバル | `$¥w+` | アプリケーション内 | nil

* 定数はメソッド内では定義できない

疑似変数 | 対応
-- | --
true | TrueClassのインスタンス
false | FalseClass
nil | NilClass
self | 現在のオブジェクト
`__FILE__` | 現在実行しているプログラムのファイル名
`__LINE__` | 現在実行しているプログラムの行番号
`__ENCODING__` | 現在のソースファイルのエンコーディング

## ロード

* require : 添付ライブラリ・ファイルの読み込み(１回)
* load    : ファイルの読み込み(何度も)
* include : モジュールの読み込み
* extend  : モジュールの読み込み for 特異オブジェクト

## **再定義不可** の演算子

名前 | 記号 | 説明
-- | -- | -- |
スコープ演算子 | `::` | あるクラスまたはモジュールで定義された定数を外部から参照する。Objectクラスで定義されているトップレベル定数の参照(左辺なしで使う)
代入演算子 | `=` |
三項演算子 | `? : ` |
範囲演算子 | `..`  | 端を含む(以下)
範囲演算子 | `...` | 端を含まない(未満)
論理演算子 | `&&` | `&&=`←代入と変わらない, 短絡評価  `p 1 && 2 #=> 2`
論理演算子 | `and` | 優先度低  `p 1 and 2 #=> 1`
論理演算子 | `｜｜` |`｜｜=`, 短絡評価  `p nil ｜｜ 2 #=> 2`
論理演算子 | `or` | 優先度低, `p 1 or 2 #=> 1`

## [例外処理](./error.rb)
error.rbに記載

## 多重代入
  * 代入方法
  ```
  a,b,c = 1,2,3
  a,b,c = [1,2,3]
  (a,b),c = [1,2],3
  a,b, *c = 1,2,3,4 #=> p c #=> [3,4]
  a,b,c =[[1,2,3],[4,5]] #a=[1,2,3], b=[4,5], c=nil


  def bar(*n1, n2, n3)
    puts "n1: #{n1}"
    puts "n2: #{n2}"
    puts "n3: #{n3}"
  end

  bar 5, 6, 7, 8
  #=> n1: [5, 6]
  #=> n2: 7
  #=> n3: 8
  ```
  * 戻り値では明示的にreturnを書く
  ```
    def foo
      return 1,2,3
    end
  ```
  * 右辺が足りない場合はnilが入る
  * 左辺が足りない場合
    * そのまま→無視される
    * 可変長引数→余った分が全部そこにはいる

# クラス

## 数値クラス

生成方法 | アウトプット | 例 | 備考
-- | -- | -- | -- |
-1 | Fixnum |
-100_000 | Fixnum | 100000
0b10 | Fixnum | 2 | 2進数表記
0o10 | Fixnum | 8 | 8進数表記
0O10 | Fixnum | 8 | 8進数表記
0d10 | Fixnum | 10 | 10進数表記
0x10 | Fixnum | 16 | 16進数表記
0bc | SyntaxError | 表現できない文字を指定した
0d1.1 | SyntaxError | 小数で指定した
1.0 | Float
3.0e2 | Float
42/10 | Fixnum | **4** ,not4.2
42/10r | Rational
42i | Complex
42ri | Complex
42ir | SyntaxError

### Numeric
メソッド | やること |
-- | -- |
ceil | 切り上げ
floor | 切り下げ
round | 四捨五入
truncate | 小数点切り捨て
abs | 絶対値
step | 繰り返し | Floatでも使える!!
numerator | 分子
denominator | 分母
real | 実部
imaginary | 虚部

### Integer  < Numeric
メソッド | やること |
-- | -- |
** | べき乗
/ | 整数同士だと小数点以下を切り捨て
chr | 対応する文字 / RangeError
next | 次の数字
succ | 次の数字
pred | 前の数字
times | 繰り返し
upto | 繰り返し
downto | 繰り返し

### Fixnum/Bignum < Integer
メソッド | やること |
-- | -- |
modulo | %
｜,&,^,~,<<,>> | ビット演算
to_f | 小数化

### Float < Numeric
### Rational / Complex
* Rational + Rational = Rational
* Rational + Integer = Rational
* **Rational + Float = Float**
* **Complex + Float/Integer = Complex**

## [String](./string_spec.rb)

Literal | What is made ? | 備考
-- | -- | -- |
`?` | １文字 or エスケープ文字 |
`<<` | Here Document | `<<-`,`<<"EOF"`,`<<'EOF'`
`%` | 文字列 | `%Q`,`%q`
`""` | 式展開可能な文字列 |
`''` | ただの文字列 |
`\` | エスケープ文字 |


カテゴリ | メソッド | 破壊的メソッド | 引数or説明 | 結果 |
-- | -- | -- | -- | -- |
エンコード | encode | encode! | 文字列 | Encoding
フォーマット | % | |  数字/文字列 | String
挿入 | | insert | 位置,文字列 | String
連結 | `+` | `<<` or `concat` | 文字列 | String
連結 | `*` | |  数字 | String
分割 | split | | 文字列,正規表現 | Array
参照 , 除外 | [], slice | slice!| (長さ),(位置,長さ),[範囲],/正規表現/ | String
変更 | | []= | (長さ),(位置,長さ),[範囲],/正規表現/ | String,範囲外はIndexError
変更 | | replace | 文字列 | String
置換 | sub | sub! | 文字列,正規表現 |String
置換 | gsub | gsub! | 文字列,正規表現 | String
置換 | tr | tr! | 文字列 | String
隣接重複削除 | squeeze | squeeze! | 文字列 | String
置換 & squeeze| tr_s | tr_s! | 文字列 | String
除外 | delete | delete! | 文字列のみ | String
除外 | chop | chop! | 末尾の文字削除 | String
除外 | chomp | chomp! | 末尾の改行削除 | String
除外 | strip | strip! | 先頭と末尾の空白削除 | String
変換 | reverse | reverse! | | String
検索 | include? | | | true/false
検索 | index | | 文字列,正規表現,位置 | Integer
検索 | scan | | 文字列,正規表現 | Array
次 | succ,next | succ!, next! ||String
整数化 | to_i | | | Integer
16進化 | hex | | `0x`,`0X`,`_`を無視 | Integer

## Symbol
生成方法 | アウトプット
-- | --
:"foo" | :foo
:'foo' | :foo
:foo | :foo
%s?foo? | :foo
"foo".to_sym | :foo

メソッド | やること |
-- | -- |
to_s |  Stringへ変換
all_symbols | すべてのシンボルを出力する


## Regexp
生成方法 | アウトプット
-- | --
%r(Hello!) | /Hello!/
/Hello!/ | /Hello!/
Regexp.new "Hello!" | /Hello!/ | compileはnewのエイリアス
Regexp.escape("ary[") | 自動エスケープ | ` "ary\\["`
Regexp.quote("ary[") | 自動エスケープ | ` "ary\\["`


メソッド | やること |
-- | --
~= | マッチした位置を返す
match | MatchDataオブジェクトを返す
=== | true/falseを返す
~ | `$_`とマッチする(最後の`gets`or`readline`)
last_match | 現在のスコープでの最後のマッチ結果のMatchDataオブジェクト
casefold? | iオプション設定済み?
source | 正規表現の文字列表現を返す
to_s | 他の正規表現に埋め込んでも動く表現を返す
m | MULTILINE (.が改行にマッチするオプション)
x | EXTENDED (空白と#、改行を無視するオプション)

組み込み変数 | 値
-- | --
$｀ | マッチ位置より前の文字列
$& | マッチした文字
$' | マッチした文字より後ろ

## [Range](./range_spec.rb)
range_spec.rbに記載

```
10.times{|d| print d == 3..d == 5 ? "T" : "F" }
Integer#timesは0からself -1までの数値を順番にブロックに渡すメソッドです。

d == 3..d == 5の部分は条件式に範囲式を記述しています。
この式は、フリップフロップ回路のように一時的に真偽を保持するような挙動をとります。
```
詳細は、[Rubyリファレンス](https://docs.ruby-lang.org/ja/2.1.0/doc/spec=2foperator.html#range)に詳しい説明がありますのでそちらを参照してください。
(Rex Ruby Examinationの解説より)


## [Array](./array_spec.rb)
[array_spec.rb](./array_spec.rb)に記載の分は基本的に省く。破壊的メソッドがあるものは、暗記のためにこちらにも必ず書く。

生成方法 | アウトプット
-- | --
Array[1,2,3] | [1,2,3]
Array.new([1,2,3]) | [1,2,3]
Array.new(3,'str') |["str", "str", "str"]
Array.new(3){｜i｜ i * 3}| [0, 3, 6]
%W(Hello! World!)| ["Hello!" "World!"]
%w(Hello! World!)| ['Hello!' 'World!']
`*"a"` | ["a"]


カテゴリ | メソッド | 破壊的メソッド | 引数or説明 | 結果 |
-- | -- | -- | -- | -- |
比較 | `==` |  | Array | true / false
比較 | `<=>` |  | Array, 自分が小さければ-1 | -1,0,1
連結 | `+` | `concat` | `["A","B"]<<["X","Y"]` |  `["A","B","X","Y"]`
追加 | | unshift |  | Array
追加 | | push,<< |  | Array
追加 | | insert |  | Array
削除 | | shift | 削除 | Objcet
削除 | | pop | 削除 | Object
削除 | | delete_at | 削除,index | Object
削除<br>参照 | [],slice | slice! |  | Object or Array
参照 | first | |  | Object
参照 | last |  |  | Object
参照 | at | |  | Object
参照 | values_at | |  | [Object]
変更 | | fill | |
変更 | | []= | |
検索 | assoc | | 配列の配列の１番目の要素を検索 | Array or nil
検索 | index | | 検索対象のobject | Fixnum
削除 | reject | delete_if, reject! | ブロックで評価して要素を削除 | self
削除 | | delete | 指定の値と`==`で等しい要素をすべて| 削除したObject
nil削除 | compact | compact! || Array
重複削除 | uniq | uniq! || Array
ソート | sort | sort! | | Array
逆順 | reverse | reverse! || Array
均す | flatten | flatten! || Array
シャッフル | shuffle | shuffle! || Array
正射影 | collect, map | collect!, map! | ブロックの評価結果で配列を作る | Array
選択 | select, find_all | select! | ブロックの評価がtrueのものだけピックアップ | Array


## Hash
生成方法 | アウトプット
-- | --
{"a"  => 1} | {"a"=>1}
{:a   => 1} | {:a=>1}
{:"a" => 1} | {:a=>1}
{:a      1} | **SyntaxError** , シンボルを作ったけど、=>がない
{:"a"    1} | **SyntaxError** , シンボルを作ったけど、=>がない
{a:      1} | {:a=>1}
{"a":    1} | {:a=>1} **(Ruby2.1ではERROR)**
[[:a,1]].to_h | {:a=>1}


カテゴリ | メソッド | 破壊的メソッド | 引数or説明 | 結果 |
-- | -- | -- | -- | -- |
比較 |
変更 | | default= | String | the string
連結 | merge | merge!, update | Hash | Hash
追加 | | []= | [key]=value | value
削除 | | delete | key | value
削除 | | shift | 先頭から | Array
参照 | [] | | [key] | value
複数参照 | values_at | | keys | Array
リスト | keys | | | Array
リスト | values | | | Array
選択 | select | select! | ブロック | Hash
選択 | find_all | | ブロック | Array
選択 | reject | reject!, delete_if | ブロック | Hash

## IO,DIR,FILE

* Dir.open
* Dir.close
* Dir.pwd
* Dir.getwd
* Dir.chdir
* Dir.mkdir
* Dir.rmdir
* Dir.unlink
* Dir.delete
* Dir.exist?
* File.open
* File.new
  * r   : ファイルの先頭
  * r+  : ファイルの先頭
  * w   : ファイルの先頭 : 既存の内容は消去 : write only
  * w+  : ファイルの先頭 : 既存の内容は消去
  * a   : ファイルの終端 : write only
  * a+  : ファイルの終端 : read write
* File.close
* File.read
* File.write
* File.dirname
* File.basename
* File.extname
* File.split    #=>["/home/gumby", ".profile"]
* File.stat
* File.lstat
* File.atime
* File.ctime
* File.mtime
* File.exist?
* File.file?
* File.directory?
* File.symlink?
* File.executable?
* File.readable?
* File.writeable?
* File.size?
* File.delete
* File.unlink
* File.truncate
* File.rename
* IO.read
* IO.foreach    #=> ブロックで１行ずつ読む     
* IO.each       #=> ブロックで１行ずつ読む
* IO.each_line  #=> ブロックで１行ずつ読む       
* IO.readlines  #=> 全部読む
* IO.readline   #=> オブジェクトが１行ずつ読む
* IO.gets       #=> オブジェクトが１行ずつ読む
* IO.stat
* IO.closed?
* IO.eof / eof?
* IO.lineno
* IO.sync
* IO.rewind
* IO.pos
* IO.seek
  * IO::SEEK_SET
  * IO::SEEK_CUR
  * IO::SEEK_END


## Time
生成方法 | アウトプット
-- | --
Time.new | 現在時刻
Time.now | 現在時刻
Time.at | 1970年+秒数の時刻
Time.mktime | (年)月日時分秒マイクロ秒 | 秒分時日月年,曜日,年日,夏時間?,タイムゾーン
Time.local | タイムゾーンがローカルで生成
Time.gm | UTCタイムゾーンで生成
Time.utc | UTCタイムゾーンで生成

メソッド | やること |
-- | -- |
usec / tv_usec | マイクロ秒
wday | 曜日0-6(日〜土)
yday | 年日0-365
gmt_offset | gmtとの差分秒
strftime | t.strftime("%Y/%m/%d")で "2017/1/13"のString

フォーマット | 意味 |
-- | -- |
%H | 24時間制
%h | 12時間制
%W | 週数(0-53)
%w | 曜日
%j | 年日


## Kernel
## Module
気になるところだけメモ

メソッド | やること |
-- | -- |
Module.constants | すべての定数を配列にして返す
constants | そのクラスの定数を配列にして返す
const_defined? | 引数の定数が定義されている？
attr_reader | インスタンス変数に対しての、読み込みメソッド
attr_writer | インスタンス変数に対しての、 書き込みメソッド
attr_accessor | インスタンス変数に対しての、 読み書きメソッド
attr | インスタンス変数に対しての、 読み書きメソッド(true),読み込みメソッド(false)
alias_method | メソッド名を文字列かシンボルで指定する
eval | 現在のコンテキストで文字列をRubyコードとして実行する
module_eval | メソッドを動的に追加する
class_eval | メソッドを動的に追加する
module_exec | 引数と一緒に、モジュールで評価する
class_exec | 引数と一緒に、クラスで評価する
include | クラスやモジュールにモジュールを追加する
extend | オブジェクトにモジュールを追加する
included | インクルードされたときに動く(フックメソッド)
extended | インクルードされたときに動く(フックメソッド)
include? |
include_modules |
autoload | 未定義の定数が参照されたら、自動的にロードする
autoload? | ロードされていなければ、そのモジュールのパス名 or nil
module_function | MyModule.myfunctionのような形で呼び出せるようにする

## Enumerable
メソッド | やること |
-- | -- |
inject | 初期値と各要素の計算を順番に行う
reduce | 初期値と各要素の計算を順番に行う
each_cons | 複数の要素のセット毎にブロックに渡す(余りが出ないように)
each_slice | 複数の要素のセット毎にブロックに渡す(余りが出たら、最後だけ少なくなる)
all? | すべての要素が真であればtrue
any? | １つでも真であればtrue
one? | １つだけが真であればtrue
member? | 指定された値と`==`で等しい要素が見つかればtrue
include? | 指定された値と`==`で等しい要素が見つかればtrue
find | ブロックを評価して最初に真となる要素を返す
detect | ブロックを評価して最初に真となる要素を返す
find_index | ブロックを評価して最初に真となる要素の位置を返す
find_all | ブロックを評価して真となる要素をすべて返す
select | ブロックを評価して真となる要素をすべて返す
sort | <=> で比較してソートした結果の配列
sort_by | ブロックの評価結果を<=>で比較した昇順の配列
max | すべての要素を<=>で比較して最大値を返す
max_by | ブロックで評価方法を記述する
count | 要素数を返す
group_by | ブロック結果が同じになる者同士を配列にまとめたハッシュ
take | firstと同じく、指定した数ぶんだけ要素を取得
take_while | 先頭からブロックを評価し、最初にFalseになった要素の直前までを配列で返す
drop | takeの逆で、指定した数ぶんだけ落とした配列を返す
drop_whild | take_whileの逆で、最初にFlaseになった要素以降を返す
select | ブロックの評価結果が真である配列を返す
reject | ブロックの評価結果が偽である配列を返す
lazy | mapなどのメソッドの評価が遅延される

## Comparable
<=>をもとにしたオブジェクト同士の比較ができるようになる
