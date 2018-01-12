describe Hash do

  attr_reader :a, :x

  before :each do
    @a = {a: 1, b: 2}
    @x = {:x => 3, :y => 4}
  end

  describe 'merge, update' do
    it 'should be {:a => 1, :b => 2, :x => 3, :y => 4}' do
      expect(a.merge(x)).to eq ({a: 1, b: 2 ,x: 3 , y: 4})
      expect(a).to eq ({a: 1, b: 2})
      expect(a.merge!(x)).to eq ({a: 1, b: 2 ,x: 3 , y: 4})
      expect(a).to eq ({a: 1, b: 2 ,x: 3 , y: 4})
    end
    it 'should be same as merge!' do
      b = a.clone
      a.merge!(x)
      expect(a).not_to eq b
      b.update(x)
      expect(a).to eq b
    end
    example 'when conflict occur, argument hash is prior' do
      expect(a.merge!({a:10,b:10,c:10})).to eq ({a:10,b:10,c:10})
      expect(a).to eq ({a:10,b:10,c:10})
    end
  end

  describe 'shift' do
    it 'should be [:a,1], and {:b => 2}' do
      expect(a.shift).to eq [:a, 1]
      expect(a).to eq ({b: 2})
    end
  end

  describe '[]=' do
    it 'insert a pair of key and value' do
      expect(a[:c]=3).to eq 3
      expect(a).to eq ({a:1,b:2,c:3})
    end
  end

  describe 'delete' do
    it 'delete a apir of key and value' do
      expect(a.delete(:a)).to eq 1
      expect(a).to eq ({b:2})
    end
  end

  describe 'values_at' do
    it 'returns the array of the value' do
      expect(a.values_at(:a)).to eq [1]
    end
    it 'returns the array of the values' do
      expect(a.values_at(:a,:b)).to eq [1,2]
    end
  end

  describe 'keys' do
    it 'should be [:a,:b]' do
      expect(a.keys).to eq [:a,:b]
    end
  end

  describe 'default=' do
    it 'change the default answer' do
      expect(a.default='not surved').to eq 'not surved'
      expect(a[:c]).to eq 'not surved'
    end
  end

  describe 'find_all' do
    it 'should be [[:a,1]' do
      expect(a.find_all{|key,value| key == :a}).to eq ([[:a,1]])
    end
  end

  describe 'reject' do
    it 'should return hash that element is false in the block' do
      expect(a.reject{|key, value| key == :a}).to eq ({b: 2})
    end
  end
  describe 'reject!' do
    example 'self is updated by the returned hash' do
      expect(a.reject!{|key, value| key == :a}).to eq ({b:2})
      expect(a).to eq ({b:2})
    end
  end
  describe 'delete_if' do
    it 'is same as reject!' do
      expect(a.delete_if{|key, value| key == :a}).to eq ({b:2})
      expect(a).to eq ({b:2})
    end
  end

  describe 'sort' do
    it 'return array of sorted hash' do
      hash = x.merge!(a)
      expect(x.sort).to eq [[:a,1],[:b,2],[:x,3],[:y,4]]
    end
  end
end
