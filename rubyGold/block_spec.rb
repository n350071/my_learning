describe 'Block' do

  attr_reader :count_obj

  before :each do
  end

  describe 'closure' do
    describe 'scope' do
      it 'remember the valiable number' do
        def count
          number = 0 #<= block外のローカル変数
          func = lambda{|i| number += i}
          func
        end

        @count_obj = count
        expect(count_obj.call(1)).to eq 1
        expect(count_obj.call(1)).to eq 2
      end
    end
    describe 'call' do
      it 'call only the block' do
        def hello
          str = 'Hello World!'
          functional_object = lambda do
            str = 'Hello from block'
          end
          str = 'Hello from closure'
          functional_object
        end
        hello_obj = hello
        expect(hello_obj.call).to eq 'Hello from block'
      end
    end
    describe 'small block' do
      example 'block is just {2}' do
        def func x
          x + yield
        end
        expect(func(1){2}).to eq 3
      end
    end
  end
end
