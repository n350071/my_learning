describe 'mix-in' do

  class Foo
    def only_Foo
      'only_Foo'
    end
    def my_name
      'Foo'
    end
  end

  class FooExt < Foo
    def my_name
      'FooExt'
    end
  end

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

  describe 'openclass' do
    it 'still has superclass' do
      class FooExt #<Foo
      end
      expect(FooExt.new.only_Foo).to eq 'only_Foo'
    end
  end

  describe 'include prior' do
    it 'refer last included module' do
      class A
        include ModA
        include ModB
      end
      expect(A.new.mod).to eq 'ModB'
    end
    it 'refer left included module first' do
      class B
        include ModA, ModB
      end
      expect(B.new.mod).to eq 'ModA'
    end
  end

  describe 'extend, include' do
    example 'singleton method is implemented in only foo1' do
      foo1 = Foo.new
      foo2 = Foo.new
      def foo1.my_name
        'foo!'
      end
      expect(foo1.my_name).to eq 'foo!'
      expect(foo2.my_name).to eq 'Foo'
    end
    example 'class << object makes a singleton class' do
      foo = Foo.new
      bar = class << foo
        def my_name
          'foo!'
        end
      end
      expect(foo.my_name).to eq 'foo!'
      expect(bar).to eq :my_name
    end
    example 'include module' do
      foo = Foo.new
      class << foo
        include ModA,ModB
      end
      expect(foo.mod).to eq 'ModA'
    end
    example 'extend the class and prior' do
      foo = Foo.new
      foo.extend(ModA)
      foo.extend(ModB)
      expect(foo.mod).to eq 'ModB'
    end
    example 'extend prior' do
      foo = Foo.new
      foo.extend(ModA,ModB)
      expect(foo.mod).to eq 'ModA'
    end
    example 'cant extend by class' do
      class C
        extend ModA  #ModAのメソッドはクラスCのクラスメソッドになる
        include ModB #ModBのメソッドはクラスCのインスタンスメソッドになる
      end
      expect(C.ancestors).to eq [C, ModB, Object, Kernel, BasicObject]
      expect(C.mod).to eq ('ModA')
      expect(C.new.mod).to eq ('ModB')
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
