describe Array do

  attr_reader :a, :x

  before :each do
    @a = ["A", "B"]
    @x = ["X", "Y"]
  end

  describe 'transpose' do
    it 'should be [[1, 3, 5], [2, 4, 6]]' do
      ary = [[1,2], [3,4], [5,6]]
      expect(ary.transpose).to eq [[1, 3, 5], [2, 4, 6]]
      expect(ary).to eq [[1,2], [3,4], [5,6]]
    end
  end

  describe 'product' do
    it 'should be [["A","X"],["A","Y"],["B","X"],["B","Y"]]' do
      expect(a.product(x)).to eq [["A","X"],["A","Y"],["B","X"],["B","Y"]]
    end
  end

  describe 'zip' do
    it 'should be [["A","X"],["B","Y"],["C",nil]]' do
      a << "C"
      expect(a.zip(x)).to eq [["A","X"],["B","Y"],["C",nil]]
    end
  end

  describe '&' do
    it 'return new Array that elements are in BOTH of the arrays' do
      a.push("C")
      expect(a & ["B","C","D"]).to eq ["B","C"]
      expect(a).to eq ["A","B","C"]
    end
  end

  describe '-' do
    it 'right - left' do
      a.push("C")
      expect(a - ["B","C","D"]).to eq ["A"]
      expect(a).to eq ["A","B","C"]
    end
  end

  describe '|' do
    it 'return new Array that elements are in AT LEAST one array' do
      expect(a | x).to eq ["A","B","X","Y"]
      expect(a).to eq ["A","B"]
    end
  end

  describe '* , join' do
    it 'cycle 3 times' do
      expect(a*3).to eq ["A","B","A","B","A","B"]
      expect(a).to eq ["A","B"]
    end
    it 'combine arrays to STRING with the string' do
      expect(a*"-").to eq "A-B"
      expect(a).to eq ["A","B"]
    end
  end

  describe 'unshift' do
    it 'add a element' do
      expect(a.unshift("Z")).to eq ["Z","A","B"]
      expect(a).to eq ["Z","A","B"]
    end
    example 'do nothing with no argument' do
      expect(a.unshift).to eq ["A","B"]
      expect(a).to eq ["A","B"]
    end
  end
  describe 'shift' do
    it 'remove a element' do
      expect(a.shift).to eq "A"
      expect(a).to eq ["B"]
    end
  end
  describe 'first' do
    it 'look at the first element' do
      expect(a.first).to eq "A"
      expect(a).to eq ["A","B"]
    end
  end

  describe '[],at,slice' do
    example '[index] at(index)' do
      expect(a[1]).to eq a.slice(1)
      expect(a.at(1)).to eq "B"
    end
    example '[start,length]' do
      expect(a[0,2]).to eq a.slice(0,2)
    end
    example '[Range]' do
      expect(a[0..1]).to eq a.slice(0..1)
    end
    example 'BANG' do
      expect(a.slice!(0..1)).to eq ["A","B"]
      expect(a).to eq []
    end
  end

  describe 'assoc' do
    it 'should return ["X","Y"]' do
      ary = [a,x]
      expect(ary.assoc("X")).to eq ["X","Y"]
    end
    it 'should return nil' do
      ary = [a,x]
      expect(ary.assoc("Z")).to be nil
      ary.push("Hello!")
      expect(ary.assoc("Hello!")).to be nil
    end
  end

  describe 'index' do
    it 'return the index of the element' do
      expect(a.index("B")).to eq 1
    end
  end

  describe 'delete_if' do
    it 'return self that should be deleted the elemtnt' do
      expect(a.delete_if{|item| item == 'A'}).to eq ["B"]
      expect(a).to eq ["B"]
    end
  end

  describe 'reject!' do
    it 'should be same as delete_if' do
      expect(a.reject!{|item| item == 'A'}).to eq ["B"]
      expect(a).to eq ["B"]
    end
  end

  describe 'delete' do
    it 'should be ["B","X","Y"]' do
      ary = a.concat(x)
      expect(ary.delete('A')).to eq "A"
      expect(ary).to eq ["B","X","Y"]
    end
  end

  describe 'collect' do
    it 'should be [false,false,true,true]' do
      ary = [0,1,2,3]
      expect(ary.collect{|x| x > 1}).to eq [false,false,true,true]
      expect(ary).to eq [0,1,2,3]
      expect(ary.collect!{|x| x > 1}).to eq [false,false,true,true]
      expect(ary).to eq [false,false,true,true]
    end
  end

  describe 'select' do
    it 'should be [2,3]' do
      ary = [0,1,2,3]
      expect(ary.select{|x| x > 1}).to eq [2,3]
      expect(ary).to eq [0,1,2,3]
      expect(ary.select!{|x| x > 1}).to eq [2,3]
      expect(ary).to eq [2,3]
    end
  end

end
