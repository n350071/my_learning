describe 'local' do
  v1 = 1
  class Local
    v2 = 2
    def getV1
      v1 #未初期化エラー
    end
    def getV2
      v2 #未初期化エラー
    end
    def getV3
      v3 = 3 if false #未代入によるnil
    end
    def getV4
      v4 = 4 #宣言も代入も完了して4
    end
  end
  local = Local.new
  example 'v1はクラス定義の外なので参照不可(getV1スコープ内で未初期化エラー)' do
    expect{local.getV1}.to raise_error (NameError)
  end
  example 'v2はインスタンスメソッドgetV2のスコープの外なので参照不可(getV2スコープ内で未初期化エラー)' do
    expect{local.getV2}.to raise_error (NameError)
  end
  example 'v3は宣言はしてるが、代入はできていないのでnil' do
    expect(local.getV3).to be nil
  end
  example 'v4は宣言も代入もできてるので、値が取れる' do
    expect(local.getV4).to eq 4
  end
end

describe 'instance valiable' do
  @v1 = 1 #この時点では代入したことにならない
  class Instance
    attr_reader :v3
    attr_writer :v3
    attr_accessor :v4
    attr :v6
    @v2 = 2 #この時点では代入したことにならない
    @v3 = 3 #この時点では代入したことにならない
    @v4 = 4 #この時点では代入したことにならない
    @v5 = 5 #この時点では代入したことにならない
    def v1
      @v1
    end
    def v2
      @v2
    end
    def v5
      @v5
    end
    def v5=(val)
      @v5 = val
    end
  end
  class InsExt < Instance
  end
  ins = Instance.new
  insExt = InsExt.new
  example '@v1はクラスのスコープ外なので、未初期化と見なされてnil' do
    expect(ins.v1).to be nil
  end
  example '@v2はクラス定義内だが、@v2=2は実行されず、未初期化とみなされてnil' do
    expect(ins.v2).to be nil
  end
  example '@v3はattr_reader,attr_writerがついているので、get set可能' do
    expect(ins.v3).to be nil
    ins.v3 = 33
    expect(ins.v3).to be 33
  end
  example '@v4はattr_accesorがついてるので、get set可能' do
    expect(ins.v4).to be nil
    ins.v4 = 44
    expect(ins.v4).to be 44
  end
  example '@v5は自前のgettr,setterを書いたので、get set可能' do
    expect(ins.v5).to be nil
    ins.v5 = 55
    expect(ins.v5).to be 55
  end
  example '@v6はattrがついてるのでreadだけ可能、代入はNoMethodError' do
    expect(ins.v6).to be nil
    expect{(ins.v6=66)}.to raise_error (NoMethodError)
  end
  example '@v3,@v4,@v5は、メソッドを通じてサブクラスからも参照可能' do
    insExt.v4 = 4
    expect(insExt.v4).to eq 4
  end
  example 'undefすると、見れなくなる' do
    class InsExt
      undef v4, v4= #v4はattr_accesorで定義していた
    end
    expect{(insExt.v4=4)}.to raise_error (NoMethodError)
    expect{(insExt.v4)}.to raise_error (NoMethodError)
  end
end

describe 'class valiable' do
  class Parent
    @@v1 #NameError
    @@v2 = 0 #この時点で宣言済みになる
    @@v3 = 0 #この時点で宣言済みになる
    def v1
      @@v1
    end
    def v2
      @@v2
    end
    def v2=(val)
      @@v2=(val)
    end
    def v3
      @@v3
    end
    def v3=(val)
      @@v3=(val)
    end
  end
  class Child < Parent
    @@v3 = 1 #再定義ではなくて代入
  end
  father = Parent.new
  mother = Parent.new
  child = Child.new
  example '@@v1は未初期化でNameError' do
    expect{father.v1}.to raise_error (NameError)
  end
  example '@@v2はクラス・サブクラス間で共有' do
    expect(father.v2).to eq 0
    mother.v2=1
    expect(child.v2).to eq 1
  end
  example 'サブクラスで再定義しても、それは実は代入である' do
    expect(father.v3).to eq 1
    mother.v3= 2
    expect(child.v3).to eq 2
  end
end

describe 'Constant' do
  module FooMod
    CONST ,MOD = 'FooMod','MOD'
    def getCONST; CONST; end
  end
  class Foo
     CONST='Foo'
     PARENT = 'PARENT'
     def self.const_missing(id)
       id
     end
     include FooMod
  end
  class FooExt < Foo; CONST = 'FooExt' end
  example '同名の定数はまず自分のところから、なければ上位を見に行く' do
    expect(Foo::CONST).to eq 'Foo'
    expect(FooMod::CONST).to eq 'FooMod'
    expect(FooExt::CONST).to eq 'FooExt'
    expect(FooExt::PARENT).to eq 'PARENT'
    expect(FooExt::MOD).to eq 'MOD'
  end
  example 'メソッドで参照すると、メソッドが定義されている位置にある定数を見る' do
    expect(FooExt.new.getCONST).to eq 'FooMod'
  end
  example '再代入可能,中身の直接変更可能' do
    Foo::CONST = [0,1]
    expect(Foo::CONST).to eq [0,1]
    Foo::CONST[0] = 1
    expect(Foo::CONST).to eq [1,1]
  end
  example 'freezeで再代入不可能,中身の直接変更可能' do
    Foo.freeze
    expect{Foo::CONST=3}.to raise_error (RuntimeError)
    Foo::CONST[0] = 2
    expect(Foo::CONST).to eq [2,1]
    Foo = Foo.dup #cloneと違ってfreeze状態はコピーしない
  end
  example '相対パスと絶対パス' do
    expect(Foo::CONST).to eq ::Foo::CONST
  end
  example 'self.const_missing(id)のidは見つからなかった定数のsymbol' do
    expect(Foo::CONST_NOT_DEFINED).to eq :CONST_NOT_DEFINED
    expect(FooExt::CONST_NOT_DEFINED).to eq :CONST_NOT_DEFINED
  end
end
