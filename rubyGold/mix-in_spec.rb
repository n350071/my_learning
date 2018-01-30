describe 'Mix-in' do
  module ModA
    def self.mod
      'self.ModA'
    end
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
    example 'クラスにモジュールのインスタンスメソッドを追加する' do
      class IncludeC
        include ModA
      end
      expect(IncludeC.new.mod).to eq 'ModA'
    end
    describe '優先度' do
      example '縦に並べた場合は、あとにincludeした方が優先' do
        class IncludeA
          include ModA
          include ModB
        end
        expect(IncludeA.new.mod).to eq 'ModB'
        #expect(IncludeA.ancestors).to eq([IncludeA,ModB,ModA,Object,Kernel,BasicObject])
      end
      example '横に並べた場合は、左が優先' do
        class IncludeB
          include ModA, ModB
        end
        expect(IncludeB.new.mod).to eq 'ModA'
        #expect(IncludeB.ancestors).to eq([IncludeB,ModA,ModB,Object,Kernel,BasicObject])
      end
    end
  end

  describe 'prepend' do
    it 'そのオブジェクトのメソッドに優先して探索される' do
      class Prepend_A
        prepend ModA # ModAがPrepend_Aのインスタンスメソッドに優先する
        def mod
          'Prepend_A'
        end
      end
      expect(Prepend_A.new.mod).to eq 'ModA'
      #expect(Prepend_A.ancestors).to eq([ModA, Prepend_A, Object, Kernel, BasicObject])
    end
    example 'super in prepended module means the class' do
      module ModC
        def mod
          super #Prepend_2にprependされた状態でのsuperはPrepend_2を指す
        end
      end
      class Prepend_2
        prepend ModC
        def mod
          'Prepend_2'
        end
      end
      expect(Prepend_2.new.mod).to eq ('Prepend_2')
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
        #expect(foo1.class.ancestors).to eq([Extend,Object,Kernel,BasicObject])
      end
    end
    describe 'クラスの特異メソッド=>クラスメソッド' do
      example 'クラスでextendするとクラスメソッドになる' do
        class Extend
          extend ModA  #クラスメソッドになる
        end
        expect(Extend.mod).to eq ('ModA')
        #includeと違ってancestorsには反映されない
        #expect(Extend.ancestors).to eq([Extend, Object, Kernel, BasicObject])
      end
    end
  end

  describe 'class <<' do
    class Single
      def mod
        'Single'
      end
    end
    example 'メソッドを定義すると、そのオブジェクトに特異メソッドを作る' do
      foo = Single.new
      bar = Single.new
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
      expect(bar.mod).to eq 'Single'
      expect{bar.special}.to raise_error (NoMethodError)
    end
    example '特異クラスでのinclude/prepend = オブジェクト.extend' do
      foo = Single.new
      bar = Single.new
      baz = Single.new
      class << foo
        include ModA
      end
      class << bar
        prepend ModA
      end
      baz.extend(ModA)
      expect(foo.mod).to eq baz.mod
      expect(bar.mod).to eq baz.mod
    end
    example '特異クラスでextendしても意味がない' do
      foo = Single.new
      bar = Single.new
      class << foo
        extend ModA
      end
      expect(foo.mod).to eq 'Single'
      expect(bar.mod).to eq 'Single'
    end
  end

  describe 'method defined method' do
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
    example 'クラスクラスを再オープンして全てのクラスクラスに有効なクラスメソッドを定義する' do
      class Class #
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
    example 'オブジェクトクラスを再オープンして全てのオブジェクトに有効なクラスメソッドを定義' do
      class Object
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

  describe 'モジュールのモジュールメソッド' do
    module M
      def self.moo
        'Mmoo'
      end

      def mod_fun
        'Mod_fun'
      end
      module_function :mod_fun
    end
    class H
      include M
      extend  M
    end
    example 'モジュールから呼べる' do
      expect(M.moo).to eq 'Mmoo'
    end
    example 'インクルード、extendしてもクラスからは呼べない' do
      expect{(H.moo)}.to raise_error(NoMethodError)
      expect{(H.new.moo)}.to raise_error(NoMethodError)
    end
    example 'module_functionも使える' do
      expect(M.mod_fun).to eq 'Mod_fun'
    end

  end
end
