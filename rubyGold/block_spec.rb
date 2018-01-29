describe 'block' do
  class Block
    def block_a
      yield
    end
    def block_b a,b
      yield(a,b)
    end
    def block_c
      return yield if block_given?
      'no block'
    end
  end
  example 'ブロック内からブロック外の変数は参照できるが、内部で宣言された変数は外からは参照できない' do
    x = 1
    expect(Block.new.block_a{y=2; x+=y}).to eq 3
    expect(x).to eq 3 # xを環境としてclosure内に閉じ込めた
    expect{y}.to raise_error (NameError)
  end
  example 'ブロックに引数を渡す' do
    expect(Block.new.block_b(1,2){|a,b| a+b}).to eq 3
  end
  example 'ブロックが渡されたか判定する' do
    expect(Block.new.block_c).to eq 'no block'
    expect(Block.new.block_c{'block given'}).to eq 'block given'
  end
  example '自作のクラスにmapを実装する' do
    class MyClass
      include Enumerable
      attr_accessor :array
      def initialize
        @array = []
      end
      def <<(val)
        @array << val
      end
      def map(&block)
        @array.map(&block)
      end
    end
    mine = MyClass.new
    mine<<1 <<2 <<3
    new_ary = mine.map{|me| me * me}
    expect(new_ary).to eq [1,4,9]
  end
end

describe 'Proc' do
  describe 'Procとyieldの違い' do
    example 'クロージャーの要件は同じで、ブロックを実行するだけのメソッドは不要' do
      x = 1
      expect(Proc.new{y=2; x+=y}.call).to eq 3
      expect(x).to eq 3 # xを環境としてclosure内に閉じ込めた
      expect{y}.to raise_error (NameError)
    end
    example 'ブロックに引数を渡すときも、メソッド不要' do
      expect(Proc.new{|a,b| a+b}.call(1,2)).to eq 3
    end
    example '予め定義しておくことも可能' do
      class Proc_sample
        def a_plus_b a,b
          Proc.new{a+b}.call
        end
      end
      expect(Proc_sample.new.a_plus_b(1,2)).to eq 3
    end
  end
  example 'Proc.new()はエラー' do
    expect{Proc.new({})}.to   raise_error (ArgumentError)
    expect{Proc.new()}.to     raise_error (ArgumentError)
    expect{Proc.new}.to raise_error (ArgumentError)
    #okのパターン
    expect(Proc.new{}.class).to eq Proc
  end
  example 'ブロックの実行方法は４つ' do
    prc = Proc.new{|str| "#{str}"}
    str = "Hello!"
    expect(prc.call(str)).to   eq str
    expect(prc.(str)).to       eq str # メソッドコールと違い.がつくことに注意する
    expect(prc.yield(str)).to  eq str # .yieldでも呼び出せる
    expect(prc[str]).to        eq str # []のときは.がつかない

    #以下はメソッドコール ()の.の違いに要注意！
    expect{prc(str)}.to raise_error (NoMethodError)
    expect{prc str}.to raise_error (NoMethodError)
  end
  example 'Procは引数の数にこだわらない' do
    prc = Proc.new{|str| "#{str}"}
    str = "Hello!"
    expect(prc.call(str,str)).to   eq str
    expect(prc.()).to              eq ""
  end
  example 'arityで引数の数を確認できる' do
    prc = Proc.new{|str| "#{str}"}
    expect(prc.arity).to eq 1
  end
  describe 'Procをブロックとしてメソッドに渡す' do
    example '&blockは１番最後の引数' do
      def func x, &block
        x + block.call
      end
      # SyntaxError
      #def bunc &block, x
      #  x + block.call
      #end
      prc = Proc.new{2}
      expect(func(1,&prc)).to eq 3
    end
  end
  describe '中断とリターンとブレイク' do
    example 'ブロックの中断' do
      prc = Proc.new{
        |x,y|
          if x > y then
            next x
          end
        y
      }
      expect(prc.(2,1)).to eq 2
    end
    example 'break,return' do
      expect{Proc.new{break}.()}.to raise_error (LocalJumpError)
      expect{Proc.new{return}.()}.to raise_error (LocalJumpError)
      expect(lambda{break''}.call).to  eq ''
      expect(lambda{return ''}.call).to eq ''
    end
  end
end

describe 'lambda' do
  describe '生成方法' do
    example 'Procと同じように引数を{}内に書く方法' do
      lmd = lambda{|a,b| a+b}
      expect(lmd.call(1,2)).to eq 3
    end
    example '->を使うときは引数は外、do-endも使える' do
      lmd = ->(a,b) do
        a+b
      end
      expect(lmd.call(1,2)).to eq 3
    end
  end
  example 'callのシンタックスシュガー' do
    lmd = ->(str){"#{str}"}
    str = "Hello!"
    expect(lmd.call(str)).to   eq str
    expect(lmd.(str)).to       eq str # メソッドコールと違い.がつくことに注意する
    expect(lmd.yield(str)).to  eq str # .yieldでも呼び出せる
    expect(lmd[str]).to        eq str # []のときは.がつかない

    #以下はメソッドコール ()の.の違いに要注意！
    expect{lmd(str)}.to raise_error (NoMethodError)
    expect{lmd str}.to raise_error (NoMethodError)
  end
  example 'lambdaは引数の数にこだわる' do
    lmd = lambda{|a,b| a+b}
    expect{lmd.(1,2,3)}.to raise_error (ArgumentError)
    expect{lmd.yield(1)}.to raise_error (ArgumentError)
  end
  example 'arityで引数の数を確認できる' do
    lmd = lambda{|a,b| a+b}
    expect(lmd.arity).to eq 2
  end
end

describe '{} vs do-end' do
  class BracesVsRoundBrackets
    def m1 (input=nil)
      str = yield if block_given?
      "#{input}m1#{str}"
    end
    def m2 (input=nil)
      str = yield if block_given?
      "#{input}m2#{str}"
    end
    def braces_win
      m1 m2 {"hello"}
    end
    def write_round_brackets_for_doend
      m1 (m2 do "hello" end)
    end
    def write_round_brackets_win_to_braces
      m1(m2){"hello"}
    end
    def doend_loose
      m1 m2 do "hello" end
    end
    def m3 (str)
      yield(str)
    end
    def braces_with_no_round_brackets
    # m3 "hey" {|str| "#{str}"}
    # #=> SyntaxError
    # #=> it should be
      m3("hey"){|str| "#{str}"}
    end
    def doend_with_no_round_brackets
      m3 "hey" do |str| "#{str}" end
    end
  end
  example '{}はメソッドの引数に優先するが、do-endは劣る' do
    expect(BracesVsRoundBrackets.new.braces_win).to eq 'm2hellom1'
    expect(BracesVsRoundBrackets.new.write_round_brackets_for_doend).to eq 'm2hellom1'
  end
  example '{}は明示的に引数を書くと引数が優先されるが、do-endは明示しなくても引数がブロックに優先する' do
    expect(BracesVsRoundBrackets.new.write_round_brackets_win_to_braces).to eq 'm2m1hello'
    expect(BracesVsRoundBrackets.new.doend_loose).to eq 'm2m1hello'
  end
  example '{}とdo-endの引数の省略' do
    expect(BracesVsRoundBrackets.new.braces_with_no_round_brackets).to eq "hey"
    expect(BracesVsRoundBrackets.new.doend_with_no_round_brackets).to eq "hey"
  end
end

describe '自作のmap, map!関数' do
  class Array
    def mymap(&prc)
      retary = []
      self.each{|val| retary << prc.call(val)}
      retary
    end
    def mymap!(&prc)
      retary = []
      self.each{|val| retary << prc.call(val)}
      self.replace(retary)
    end
  end
  prc = Proc.new{|val| val**2}
  ary = [1,2,3]
  aryid = ary.object_id

  example 'mapと同じ結果になる' do
    expect(ary.mymap(&prc)).to eq ary.map(&prc)
  end
  example 'mapは自身は変更しない' do
    expect(ary).to eq [1,2,3]
  end
  example 'map!と同じ結果になる' do
    ary2 = ary.dup
    expect(ary.mymap!(&prc)).to eq ary2.map!(&prc)
  end
  example 'map!は自身を変更するが、オブジェクトidはそのまま' do
    expect(ary).to eq [1,4,9]
    expect(ary.object_id).to eq aryid
  end
end
