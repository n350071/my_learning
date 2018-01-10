# RubySilverの試験範囲の知識を体系化して記憶を定着させる

---

# インプット
* 教科書
  * はじめてRuby←数年前に読んだ
  * Ruby技術者認定試験合格教本
  * オブジェクト指向設計実践ガイド
  * Design Patterns in Ruby
  * Refactoring Ruby Edition
* 問題集
  * Ruby技術者認定試験合格教本
  * http://www.ruby.or.jp/ja/certification/examination/rex
  * https://gist.github.com/sean2121/945035ef2341f0c39bf40762cd8531e0

---

# 文法

## コメント

* `#` 以降がコメント
* マジックコメント
  * 行頭のコメント
  * エンコーディングを伝えるコメント
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

疑似変数 | 対応
-- | --
true | TrueClassのインスタンス
false | FalseClass
nil | NilClass
self | 現在のオブジェクト
`__FILE__` | 現在実行しているプログラムのファイル名
`__LINE__` | 現在実行しているプログラムの行番号
`__ENCODING__` | 現在のソースファイルのエンコーディング

## 演算子

気をつけたい演算子のみ

* 演算子(再定義不可)
  * スコープ演算子
    * `::`
      * あるクラスまたはモジュールで定義された定数を外部から参照する
      * Objectクラスで定義されているトップレベル定数の参照(左辺なしで使う)
  * 代入演算子
    * `=` :
  * 三項演算子
    * `?:` :
  * 範囲演算子
    * `..`  : 端を含む(以下)
    * `...` : 端を含まない(未満)
  * 論理演算子
    * かつ
      * `&&` : 自己代入可能,
        * 左がfalseのとき短絡評価
        * 最後の計算結果を返す
        * `p 1 && 2 #=> 2`
      * `and` : 優先度低,
        * `p 1 and 2 #=> 1`
    * または
      * `||` : 自己代入可能,
        * `||=` 初期化してなければ=の右側のものを代入して初期化
        * 左がtrueのとき短絡評価
        * 最後の計算結果を返す
        * `p 1 || 2 #=> 1`
        * `p nil || 2 #=> 2`
      * `or` : 優先度低,
        * `p 1 or 2 #=> 1`
* メソッドとして定義されている演算子（各クラスでオーバーライド可能）
  * 同値判断
    * Reference
      * `equal?`
    * Value
      * `eql?` : `==`より厳しく型のチェックも行うことが多い
      * `==`
      * `===` : case式で同じ値かどうかの判断に利用
        * 通常のオブジェクト: 同じ値かどうか？
        * Range:包含判定 (`case 7 when 1..10 #=> 7 === 1..10`)
        * 正規表現:指定オブジェクトが正規表現にマッチするか？
  * 大小判断
    * `<=>`

## 条件分岐
* if式 : 計算結果(if~end)/nilを返す
  * 文法
```
if <expression> [then]
[elsif]
[else]
end
```
* unless式: if文の逆

## ループ
* for式
  * スコープが作成されない(式なので)
  *
```
for <iterator> in <Expression> do
end
```

## 例外処理
## メソッド呼び出し
* 多重代入
  * 代入方法
  ```
  a,b,c = 1,2,3
  a,b,c = [1,2,3]
  (a,b),c = [1,2],3
  a,b, *c = 1,2,3,4 #=> p c #=> [3,4]
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

## ブロック
## メソッド定義
## クラス定義

* superclass
* ancestors

## モジュール定義
## 多言語対応

# 組み込みライブラリ

## Object

メソッド | やること |
-- | -- |
methods | メソッド一覧 | public〜private, singleton
dup | 自身のみ複製 | 汚染状態
clone | 自身のみ複製 | 凍結状態
freeze | 凍結させる
taint | 汚染させる
tainted? | 汚染してる?

## 数値クラス

生成方法 | アウトプット
-- | --
-1 | Fixnum
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



## String
生成方法 | アウトプット
-- | --
?R | "R" || ?記法
?¥C-v | "\u0016" | Ctrl + v | ?記法
"\cv" | "\u0016" | Ctrl + v | ¥記法
?¥M-a | "\xE1" | Meta + a| ?記法
?¥n | "¥n" | 改行| ?記法
"abcd" | "abcd" | 式展開可能 | ¥記法可能
"ab" 'cd' | "abcd" | 式展開可能 | ¥記法可能
'ab' "cd" | "abcd" | 式展開可能 | ¥記法可能
'abcd' | 'abcd'
`<<EOF` <br>Hello!#{a} <br> `EOF` | "Hello! World!\n" | 基本形。式展開可能 | ヒアドキュメント | a = " World!"
`<<EOF` <br>Hello! <br> 　EOF<br>`EOF` | "Hello!¥nEOF" | 終端識別子の前にスペースがある
`<<-EOF` <br>Hello! EOF<br>　`EOF` | "Hello! EOF¥n" | `-`による終端識別子の前のスペース無視
`<<'EOF'` <br>Hello!#{a}<br> `EOF` | "Hello!\#{a}\n" | `''`による式展開無効化
`<<"EOF"` <br>Hello!#{a}<br> `EOF` |  "Hello! World!\n" | `""`による式展開明示
%#"Hello!"# |  "\"Hello!\"" | #で囲む | %記法
%Q[Hello!] | "Hello!" | []で囲む, デフォはQ
%q(Hello!) | "Hello!" | q->シングルクオートと同等
%x(date) | "Tue Jan  9 18:19:31 JST 2018\n" | OSへコマンド出力の結果
｀date｀ | "Tue Jan  9 18:19:31 JST 2018\n" | 終了ステータスは`$?`変数
sprintf("result: %03d", 23) | "result: 023" | %メソッドと同じ結果 | フォーマット指定

* 式展開
  * `#{}`
  * `to_s`メソッドが呼び出される
    * 独自クラスでも`to_s`を定義すれば`#{}`で使える
* ¥記法
  * エスケープ
    * ¥C-x, ¥cx

メソッド | やること |
-- | -- |
p |  inspectで出力|  引数毎に改行 `'\s'->"\\s"`
puts |  to_sで出力|  引数毎に改行  `" "`
print |  to_sで出力|  改行しない  `" "`
% | フォーマットへ引数をあてて出力  `"%03d"%23 #=> "023"`
center | 中央割付で出力
ljust | 左寄せで出力
rjust | 右寄せで出力
`+` |  連結
**<<** | 連結
**concat** | 連結
＊ |  連結の繰り返し
encoding |  エンコード確認
**encode!** |  エンコードセット
[] | 要素を取り出す(なければnil) | 位置(と長さ),範囲,部分文字,正規表現
**slice!** | 要素を取り除く(出す) | []と同じ
**[]=** | 指定要素を変更する
**replace!** | 指定された文字に入れ替える | object_idは変わらない
**insert** | 指定位置に挿入する
split | 分割した配列を返す
**sub!** | 置換する(最初のマッチだけ)
**gsub!** | 置換する(全てのマッチを)
**tr!** | 置換する(パターンに含まれる文字を)
**tr_s!** | 置換して重複を消す(パターンに含まれる文字を)
**squeeze!** | 重複を消す(指定文字の)
**capitalize!** | 先頭を大文字にし、残りを小文字にする
**upcase!** | すべて大文字にする
**downcase!** | すべて小文字にする
**swapcase!** | 大文字小文字を入れ替える
**delete!** | 文字削除(複数パターンの∧条件)
**chop!** | 文字削除(末尾の)
**chomp!** | 改行削除(末尾から指定の)
**strip!** | 空白文字を削除(先頭と末尾の) | `¥t,¥r,¥n,¥f,¥v`
**lstrip!** | 空白文字を削除(先頭の)
**rstrip!** | 空白文字を削除(末尾の)
**reverse!** | 逆順にする
count | 指定のパターンに該当する文字数
empty? | 空文字?
bytesize | バイト長
include? | 指定された文字を含む?
index | 文字やパターンで位置を検索
rindex | 文字やパターンで位置を右から検索
match | 文字やパターンでの検索結果をMatchDataオブジェクトで返す
scan | 正規表現で検索した部分文字列の配列 | ["c","d"]
**succ!** | 次の文字
**next!** | 次の文字
each_line | 行毎の繰り返し | lines
each_char | 文字毎の繰り返し | chars
each_byte | バイト単位の繰り返し | bytes
upto | 自身から指定文字までsuccによる繰り返し
to_i |  整数化 | `"12ab3"->12` , `"1.2"->1`
to_f |  小数化
to_r |  実数化
to_c |  複素数化
hex | 16進数化 | `0x`,`0X`,`_`が無視される
oct | 8進数化 | 接頭辞に応じて変換を変えられる
to_sym | シンボル化 | intern
dump | 改行コード、タブ文字などを¥記法に置き換える | `puts "¥t".dump`

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

## Range
生成方法 | アウトプット
-- | --
1..10 | 1から10以下の範囲
1...10 | 1から10未満の範囲


メソッド | やること |
-- | --
== |   同値?
=== |  含む?
.include?|  含む?


## Array
生成方法 | アウトプット
-- | --
Array[1,2,3] | [1,2,3]
Array.new([1,2,3]) | [1,2,3]
Array.new(3,'str') |["str", "str", "str"]
Array.new(3){｜i｜ i * 3}| [0, 3, 6]
%W(Hello! World!)| ["Hello!" "World!"]
%w(Hello! World!)| ['Hello!' 'World!']

メソッド | やること |
-- | -- |
== | 配列同士の要素がそれぞれ全て等しければtrueを返す
<=> | 配列同士の要素がそれぞれ全て等しければ0,どこかで大小あれあ-1or1
product | ２つの配列の直積
zip | ２つの配列の列同士を配列にした要素にzipした配列を返す
& |  ２つの配列の重複要素の配列を返す
｜ | ２つの配列のどちらかに含まれる要素の配列を返す
`-` | 右側の配列の要素を１つも含まない配列を返す
`*` | 配列の繰り返し or 指定文字で配列の連結した文字列を返す
join | 指定文字で配列の連結した文字列を返す
`+` | ２つの配列の連結
**concat** | 配列の連結
**<<** | 要素を末尾へ追加
**push** | 要素を末尾へ追加
**unshift** | 要素を先頭へ追加
**[]=** | 配列の要素を変更する
**fill** | 全要素を指定したオブジェクトに変更
**replace** | 指定された配列に置き換える | String.replaceと違って **常に破壊的**
**insert** | 指定の位置へ挿入する
[] | 要素の参照
**slice!** | 指定のインデックスを取り出し(参照) | 範囲、始点と長さ指定可能
at | 要素の参照(引数は整数のみ受付)
values_at | 要素の参照(配列で返す)
fetch | 要素の参照 | IndexError時の動作をブロックに書ける
first | 先頭の要素の参照
last | 末尾の要素の参照
assoc | 配列の配列を`==`で検索
rassoc | 配列の配列の[1]を`==`で検索
include? | 配列の要素に含まれているか？
index | 指定された値と`==`で等しい位置を前から検索
rindex | 指定された値と`==`で等しい位置を後ろから検索
**delete_at** | 指定のインデックスを削除 | 削除した要素を返す
**delete_if** | ブロックの評価結果が真になる要素をすべて消す
**reject!** | delete_ifと同じ
**delete** | 指定の値と`==`で等しい要素をすべて消す
**clear** | 要素をすべて消す
**shift** | 先頭の要素を返して削除
**pop** | 末尾の要素を返して削除
each | 各要素をブロックへ渡す繰り返し
reverse_index | 逆順で各要素をブロックへ渡す繰り返し
cycle | 各要素をブロックへ渡す無限の繰り返し
each_index | 各インデックスをブロックへ渡す繰り返し
**sort!** | <=>を用いてソートする
**uniq!** | 重複を取り除く
**compact!** | nilを除いた配列
**reverse!** | 要素を逆順にした配列
**flatten** | 配列を一定の深さにならす
**collect** | 要素毎にブロックの評価結果に置き換え
**map** | 要素毎にブロックの評価結果に置き換え
**shuffle** | 要素をシャッフルする


## Hash
生成方法 | アウトプット
-- | --
{"a" => 1} | {"a"=>1}
{a: 1} | {:a=>1}
{:a => 1} | {:a=>1}
[[:a,1]].to_h | {:a=>1}
Hash.new("none") | {} | 要素がなければ"none"を返す
Hash.new{｜hash,key｜ hash[key]=nil} | {}

メソッド | やること |
-- | -- |
default= | 要素がないときの応答を設定する
[] | キーに対応する値
values_at | キーに対応する値
keys | キーの配列
values | 値の配列
fetch | キーに対応する値 | キーがなければ引数かブロックの結果を返す
select | キーと値を引数に、ブロックが真となる**ハッシュ**を返す
find_all | キーと値を引数に、ブロックが真となる**配列**を返す
**[]=** | 要素の変更 or 追加
**delete** | キーの削除
**reject!** | ブロックで評価した結果が真になる値を除いたハッシュを返す
**delete_if** | reject!と同じ
**replace** | 自身を置き換える | object_idは変わらず
**shift** | 先頭のハッシュを取り除き、配列にして返す
**merge!** | ハッシュのマージ
**update** | merge!と同じ
invert | キーとバリューの入れ替え
**clear** | 空にする
each | ブロックにキーと値を渡して評価する
each_pair | ブロックにキーと値を渡して評価する
each_key | ブロックにキーを渡して評価する
each_value | ブロックに値を渡して評価する
sort | ソートした配列を返す
to_a | 配列を返す

## IO
あぶないところだけ

メソッド | やること |
-- | -- |
read | ファイルを読む(指定があれば、その長さだけ)
foreach | 各行をブロックで読む | なにもしない
each | 各行をブロックで読む | なにもしない
each_lines | 各行をブロックで読む | なにもしない
each_byte | 各バイトをブロックで読む | なにもしない
each_char | 各文字をブロックで読む | なにもしない
readlines | 全部読んで配列を返す | []
readline | IOオブジェクトから１行読む | EOFError / nil
gets | IOオブジェクトから１行読む | EOFError / nil
getbyte | IOオブジェクトから１バイト読む | EOFError / nil
readbyte |IOオブジェクトから１バイト読む | EOFError / nil
getc |IOオブジェクトから１文字読む | EOFError / nil
readchar | IOオブジェクトから１文字読む | EOFError / nil
rewind | ファイルポインタを先頭に移動し、linenoの値を0にする

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

# オブジェクト指向
## ポリモルフィズム
## 継承
## mix-in
