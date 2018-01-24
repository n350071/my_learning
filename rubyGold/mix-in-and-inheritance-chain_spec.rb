describe 'Mix-in and Inheritance Chain' do
  module ModA
    def mod
      'ModA'
    end
    def foomoda
      'foomoda'
    end
  end

  module ModB
    def mod
      'ModB'
    end
    def foomodb
      'foomodb'
    end
  end

  describe 'include' do
    describe '優先度' do
      example '縦に並べた場合は、あとにincludeした方が優先' do
        class IncludeA
          include ModA
          include ModB
        end
        expect(IncludeA.new.mod).to eq 'ModB'
        expect(IncludeA.ancestors).to eq [IncludeA,ModB,ModA,Object,Kernel,BasicObject]
      end
      example '横に並べた場合は、左が優先' do
        class IncludeB
          include ModA, ModB
        end
        expect(IncludeB.new.mod).to eq 'ModA'
        expect(IncludeB.ancestors).to eq [IncludeB,ModA,ModB,Object,Kernel,BasicObject]
      end
    end
  end

  describe 'extend' do
    class Extend
      def mod
        'Extend'
      end
    end
    describe 'インスタンスの特異メソッド' do
      example '縦に並べた場合は、あとにextendした方が優先' do
        foo = Extend.new
        foo.extend(ModA)
        foo.extend(ModB)
        expect(foo.mod).to eq 'ModB'
      end
      example '横に並べた場合は、左が優先' do
        foo = Extend.new
        foo.extend(ModA,ModB)
        expect(foo.mod).to eq 'ModA'
      end
      example '他のインスタンスには影響しないし、クラスのancestorsに出てこない' do
        foo1 = Extend.new
        foo2 = Extend.new
        foo1.extend(ModA)
        expect(foo2.mod).to eq 'Extend'
        expect(foo1.class.ancestors).to eq [Extend,Object,Kernel,BasicObject]
      end
    end
    describe 'クラスの特異メソッド=>クラスメソッド' do
      example 'クラスでextendするとクラスメソッドになる' do
        class Extend
          extend ModA  #クラスメソッドになる
        end
        expect(Extend.mod).to eq ('ModA')
        #includeと違ってancestorsには反映されない
        expect(Extend.ancestors).to eq [Extend, Object, Kernel, BasicObject]
      end
    end
  end


  describe 'class << object' do
    example 'メソッドを定義すると、そのオブジェクトに特異メソッドを作る' do
      foo = Extend.new
      bar = Extend.new
      class << foo
        def mod
          'singleton'
        end
        def special
          'special'
        end
      end
      expect(foo.mod).to eq 'singleton'
      expect(foo.special).to eq 'special'
      expect(bar.mod).to eq 'Extend'
      expect{bar.special}.to raise_error (NoMethodError)
    end
    example 'includeしても、そのオブジェクトの特異メソッドになる' do
      foo = Extend.new
      bar = Extend.new
      class << foo
        include ModA
      end
      expect(foo.mod).to eq 'ModA'
      expect(bar.mod).to eq 'Extend'
    end
    example 'extendすると、クラスメソッドになる' do
      foo = Extend.new
      bar = Extend.new
      class << foo
        extend ModA
      end
      expect(Extend.mod).to eq 'ModA'
      expect(foo.mod).to eq 'Extend'
      expect(bar.mod).to eq 'Extend'
    end
  end



  describe 'prepend' do
    it 'insert under the class' do
      class C1
        prepend ModA # ModAがC1のインスタンスメソッドに優先する
        def mod
          'C1'
        end
      end
      class C2
        include ModA
        def mod
          'C2'
        end
      end
      expect(C1.new.mod).to eq 'ModA'
      expect(C1.ancestors).to eq [ModA, C1, Object, Kernel, BasicObject]
      expect(C2.new.mod).to eq 'C2'
      expect(C2.ancestors).to eq [C2, ModA, Object, Kernel, BasicObject]
    end
    example 'super in prepended module means the class' do
      module ModC
        def mod
          super + 'ModC' #C3にprependされた状態でのsuperはC3を指す
        end
      end
      class C3
        prepend ModC
        def mod
          'C3'
        end
      end
      expect(C3.new.mod).to eq ('C3ModC')
    end
  end


  describe 'method define method' do
    example 'inside method isnt def until outside is run' do
      def foo
        def bar # fooが実行されるまで実行できない
          'bar'
        end
        'foo'
      end
      begin
        bar   # １回目の実行はNameErrorが正解
      rescue NameError => e
        expect(e.class).to eq NameError
      else
        expect(true).to be false
      end
      expect(foo).to eq 'foo'
      expect(bar).to eq 'bar'
    end
  end


  describe 'class method' do
    example 'def class method for ALL Class class' do
      class Class #クラスクラスを再オープン
        def hello
          'Hello World!'
        end
      end
      class HelloWorld
      end
      expect(HelloWorld.hello).to eq 'Hello World!'
      expect(Fixnum.hello).to eq 'Hello World!'
      expect(String.hello).to eq 'Hello World!'
    end
    example 'def class method for ALL class' do
      class Object #オブジェクトクラスを再オープン
        def hello
          'Hello World!'
        end
      end
      class HelloWorld
      end
      expect(1.hello).to eq 'Hello World!'
      expect(HelloWorld.hello).to eq 'Hello World!'
      expect(Fixnum.hello).to eq 'Hello World!'
      expect(String.hello).to eq 'Hello World!'
    end

    example 'def class method for a class' do
      class D
        def D.foo
          'Dfoo'
        end
      end
      expect(D.foo).to eq 'Dfoo'
    end
    example 'def class method for a class' do
      class E
        def self.foo
          'Efoo'
        end
      end
      expect(E.foo).to eq 'Efoo'
    end
    example 'def class method for a class' do
      class F
        class << self
          def foo; 'Ffoo'; end
          def bar; 'Fbar'; end
        end
      end
      expect(F.foo).to eq 'Ffoo'
      expect(F.bar).to eq 'Fbar'
    end
    example 'def class method for a class' do
      class G
        class << G
          def foo; 'Gfoo'; end
          def bar; 'Gbar'; end
        end
      end
      expect(G.foo).to eq 'Gfoo'
      expect(G.bar).to eq 'Gbar'
    end
  end

  describe 'Module singleton method' do
    module M
      def self.moo
        'Mmoo'
      end
    end
    class H
      include M
      extend  M
    end
    example 'the self means the Module, moo is the singleton method of M' do
      expect(M.moo).to eq 'Mmoo'
    end
    example 'class H cant call moo' do
      expect{(H.moo)}.to raise_error(NoMethodError)
      expect{(H.new.moo)}.to raise_error(NoMethodError)
    end

  end
end
