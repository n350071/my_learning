describe Range do

  attr_reader :range

  before :each do
    @range = 1..10
  end

  describe 'new' do
    it 'should be 1..10' do
      expect(Range.new(1,10,false)).to eq range
    end
  end

  describe '=== and include?' do
    it "is include 10" do
      expect(range === 10 ).to be true
    end
    it "is same as include?" do
      expect(range === 10 ).to be range.include?(10)
    end
  end

  describe '==' do
    it "is same the range" do
      expect(range).to eq Range.new(1,10,false)
    end
  end
end
