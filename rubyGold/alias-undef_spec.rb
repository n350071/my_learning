describe 'alias' do
  describe 'method' do
    def method; 'method' end
    example '識別子で指定する' do
      alias old_method method
      expect(old_method).to eq 'method'
    end
    example 'Symbolで指定する' do
      alias :too_old_method :method
      expect(too_old_method).to eq 'method'
    end
    example '古いメソッドも使える' do
      expect(method).to eq 'method'
    end
  end
  describe 'global valiable' do
    $X = 'global'
    example '識別子で指定する(シンボルで指定するとSyntaxError)' do
      alias $Y $X
      expect($Y).to eq 'global'
    end
  end
end
describe 'undef' do
  example 'メソッド定義前はエラー' do
    expect{undef old_method, too_old_method}.to raise_error (NameError)
  end
  describe 'super class and module' do
    module Mod
      def mod
        'mod'
      end
    end
    class Parent
      include Mod
      def parent
        'parent'
      end
    end
    class Child < Parent
      include Mod
      def mod
        'child'
      end
      def parent
        'child'
      end
      def undef_mod
        undef mod
      end
      def undef_parent
        undef parent
      end
    end
    child = Child.new
    child2 = Child.new
    parent = Parent.new
    example 'そのクラスからは完全に取り除く' do
      expect(child.parent).to eq 'child'
      expect(child2.parent).to eq 'child'
      expect(parent.parent).to eq 'parent'
      child.undef_parent
      expect{child.parent}.to raise_error (NoMethodError)
      expect{child2.parent}.to raise_error (NoMethodError)
    end
    example '親には影響しない' do
      expect{child.parent}.to raise_error (NoMethodError)
      expect(parent.parent).to eq 'parent'
    end
    example 'モジュールも同様' do
      expect(child.mod).to eq 'child'
      expect(child2.mod).to eq 'child'
      expect(parent.mod).to eq 'mod'
      child.undef_mod
      expect{child.mod}.to raise_error(NoMethodError)
      expect{child2.mod}.to raise_error(NoMethodError)
      expect(parent.mod).to eq 'mod'
    end
  end
end
