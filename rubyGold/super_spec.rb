describe 'super' do
  class Parent
    def arguments_over(*)
      'no problem'
    end
    def arguments_less(*)
      "the arguments : #{a},#{b},#{c}"
    end
  end
  class Child < Parent
    def arguments_over(a,b,c)
      super
    end
    def arguments_less(a,b,c)
      super
    end
  end
  describe '(*)' do
    example '引数が多い場合、問題なく省く' do
      expect(Child.new.arguments_over(1,2,3)).to eq 'no problem'
    end
    example '引数が足りない場合は、値がわからなくてエラーになる' do
      expect{Child.new.arguments_less(1,2,3)}.to raise_error(NameError)
    end
  end
end
