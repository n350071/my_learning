describe 'self' do
  module Self_M
    def ans_self
      self #呼び出したオブジェクトを指すことに注意
    end
    def self.ans_self
      self
    end
    self
  end
  class Self
    def ans_self
      self
    end
    def self.ans_self
      self
    end
    self
  end
  class Self_EXTA < Self
  end
  class Self_EXTB < Self
    def ans_self
      self
    end
    def self.ans_self
      self
    end
    self
  end
  class Self_EXTC < Self
    include Self_M
  end
  describe 'self in module means the module' do
    example {
      expect(Self_M).to eq Self_M
      expect(Self_M.ans_self).to eq Self_M
    }
  end
  describe 'self in class means the class' do
    example {
      expect(Self).to eq Self
      expect(Self_EXTA).to eq Self_EXTA
      expect(Self_EXTB).to eq Self_EXTB
      expect(Self_EXTC).to eq Self_EXTC
    }
  end
  describe 'self in method means the receiver' do
    example 'class method => receiver is the class' do
        expect(Self.ans_self).to eq Self
        expect(Self_EXTA.ans_self).to eq Self_EXTA
        expect(Self_EXTB.ans_self).to eq Self_EXTB
        expect(Self_EXTC.ans_self).to eq Self_EXTC
    end
    example 'instance method => receiver is the calling one' do
      s = Self.new
      s_A = Self_EXTA.new
      s_B = Self_EXTB.new
      s_C = Self_EXTC.new
      expect(s.ans_self).to eq s
      expect(s_A.ans_self).to eq s_A
      expect(s_B.ans_self).to eq s_B
      expect(s_C.ans_self).to eq s_C
    end
  end
  describe 'self in block is the receiver' do
    example 'block in method' do
      class Self_block
        def *(input)
          input * input
        end
        def s_block(ary)
          ary.map(&self.method(:*))
        end
        def self_proc
          Proc.new{self}
        end
      end
      self_block = Self_block.new
      expect(self_block.s_block([1,2,3])).to eq [1,4,9]
      expect(self_block.self_proc.call).to eq self_block
    end
  end
end
