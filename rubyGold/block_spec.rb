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
end

describe '{} vs do-end' do
  class Vs
    def m1 (input=nil)
      str = yield if block_given?
      "#{input}m1#{str}"
    end
    def m2 (input=nil)
      str = yield if block_given?
      "#{input}m2#{str}"
    end
    def block_to_m2_1
      m1 m2 {"hello"}
    end
    def block_to_m2_2
      m1 (m2 do "hello" end)
    end
    def block_to_m1_1
      m1(m2){"hello"}
    end
    def block_to_m1_2
      m1 m2 do "hello" end
    end
  end
  example '{}はメソッドの引数に優先するが、do-endは劣る' do
    expect(Vs.new.block_to_m2_1).to eq 'm2hellom1'
    expect(Vs.new.block_to_m2_2).to eq 'm2hellom1'
  end
  example '{}は明示的に引数を書くと引数が優先されるが、do-endは明示しなくても引数がブロックに優先する' do
    expect(Vs.new.block_to_m1_1).to eq 'm2m1hello'
    expect(Vs.new.block_to_m1_2).to eq 'm2m1hello'
  end
end

describe 'Block_old' do

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
    describe 'Proc with no block' do
      example 'Proc.new and pass it' do
        def proc_form
          Proc.new
        end
        proc = proc_form{'hello'}
        expect(proc.call).to eq 'hello'
      end
      example 'Proc.new and run it' do
        def proc_form
          Proc.new
        end
        expect(proc_form{'hello'}.call).to eq 'hello'
      end
    end
  end
end
