describe String do

  attr_reader :str

  before :each do
    @str = "abcde"
  end

  describe 'slice(), slice!()' do
    it "gets substring" do
      expect(str.slice(3)).to eq "d"
      expect(str.slice(-3)).to eq "c"
      expect(str.slice(0..2)).to eq "abc"
      expect(str.slice(0..99)).to eq "abcde"
      expect(str.slice("abc")).to eq "abc"
      expect(str.slice(/[a-e]../)).to eq "abc"
      expect(str).to eq 'abcde'
    end
    it 'slice! is bang' do
      expect(str.slice!(0..2)).to eq "abc"
      expect(str).to eq "de"
    end
  end

  describe '[]' do
    it 'is same as slice()' do
      expect(str[3]).to eq str.slice(3)
      expect(str[-3]).to eq str.slice(-3)
      expect(str[0..2]).to eq str.slice(0..2)
      expect(str[0..99]).to eq str.slice(0..99)
      expect(str["abc"]).to eq str.slice("abc")
      expect(str[/[a-e]../]).to eq str.slice(/[a-e]../)
    end
  end

  describe '[]=' do
    it 'change the value, and BANG' do
      expect(str["bcd"]="BCD").to eq 'BCD'
      expect(str).to eq 'aBCDe'
    end
    it 'change the value, and BANG' do
      expect(str[1,3]="BCD").to eq 'BCD'
      expect(str).to eq 'aBCDe'
    end
    it 'change the value, and BANG' do
      expect(str[1..3]="BCD").to eq 'BCD'
      expect(str).to eq 'aBCDe'
    end
    it 'change the value, and BANG' do
      expect(str[/bcd/]="BCD").to eq 'BCD'
      expect(str).to eq 'aBCDe'
    end

  end

  describe 'casecmp and <=>' do
    it "do <=> without check A,a" do
      expect("ABC".casecmp("abc")).to eq 0
      expect("ABC"<=>"abc").to eq -1
    end
  end

  describe 'split' do
    it 'split a string and return a array' do
      expect(str.split('c')).to eq ["ab","de"]
      expect(str.split(/c/)).to eq ["ab","de"]
      expect(str).to eq "abcde"
    end
  end

  describe 'sub and sub!' do
    it 'replace the first much' do
      str = "abcde-abcde"
      expect(str.sub("bcd","BCD")).to eq 'aBCDe-abcde'
      expect(str).to eq 'abcde-abcde'
      expect(str.sub(/bcd/,"BCD")).to eq 'aBCDe-abcde'
      expect(str).to eq 'abcde-abcde'
      expect(str.sub!(/bcd/,"BCD")).to eq 'aBCDe-abcde'
      expect(str).to eq 'aBCDe-abcde'
    end
  end

  describe 'gsub and gsub!' do
    it 'replace the ALL much' do
      str = "abcde-abcde"
      expect(str.gsub(/bcd/,"BCD")).to eq 'aBCDe-aBCDe'
      expect(str).to eq 'abcde-abcde'
      expect(str.gsub!(/bcd/,"BCD")).to eq 'aBCDe-aBCDe'
      expect(str).to eq 'aBCDe-aBCDe'
    end
  end

  describe 'tr' do
    it 'replace the ALL much to specified pattern' do
      str = "abcde-abcde"
      expect(str.tr('b-d','B-D')).to eq 'aBCDe-aBCDe'
      expect(str).to eq "abcde-abcde"
    end
  end

  describe 'tr_s' do
    it 'tr and compress same char' do
      str = 'aabbccddee-aabbbbbbbbbcccccccccde'
      expect(str.tr_s('a-c','A-C')).to eq 'ABCddee-ABCde'
      expect(str).to eq 'aabbccddee-aabbbbbbbbbcccccccccde'
    end
  end

  describe 'delete, delete!' do
    it 'delete specfied string' do
      str = '0123456789-'
      expect(str.delete('0-6!XY-')).to eq '789'
      expect(str).to eq '0123456789-'
      expect(str.delete('^13-56-')).to eq '13456-' #Pattern
      expect(str.delete('1-9','2-9')).to eq '01-' #Pattern
      expect(str.delete!('0-6!XY-')).to eq '789'
      expect(str).to eq '789'
    end
  end

  describe 'index' do
    it 'returns the index of the pattern' do
      str = 'find!find!find!find!find!'
      expect(str.index("!")).to eq 4
      expect(str.index("!",5)).to eq 9
    end
    it 'should ok for Regexp too' do
      str = 'find!find!find!find!find!'
      expect(str.index(/!/)).to eq 4
      expect(str.index(/!/,5)).to eq 9
    end
  end

  describe 'scan' do
    it 'returns array of the much string' do
      str = 'find!find!find!find!find!'
      expect(str.scan(/find!/)).to eq ["find!","find!","find!","find!","find!"]
    end
  end

  describe '%' do
    it 'returns a formatted string' do
      str = "%05d"
      expect(str%23).to eq "00023"
      expect(str).to eq "%05d"
    end
  end

  describe 'replace' do
    it 'change string' do
      expect(str.replace("xyz")).to eq "xyz"
      expect(str).to eq "xyz"
    end
  end

  describe 'insert' do
    it 'insert a string' do
      expect(str.insert(1,"xyz")).to eq 'axyzbcde'
      expect(str).to eq 'axyzbcde'
    end
  end

  describe 'squeeze' do
    it 'delete side duplication of char' do
      str = 'aa-bb-cc-aa'
      expect(str.squeeze).to eq 'a-b-c-a'
    end
    it 'delete side duplication of char' do
      str = 'aa-bb-cc-aa'
      expect(str.squeeze('a')).to eq 'a-bb-cc-a'
    end
    example 'tr_s is same as tr and squeeze' do
      str = 'aa-bb-cc-aa'
      expect(str.tr_s('abc-','xyz+')).to eq str.tr!('abc-','xyz+').squeeze
    end
  end

  describe 'chomp' do
    it 'delete ¥n at last one' do
      str = 'Hello¥nWorld!¥n'
      expect(str.chomp('¥n')).to eq 'Hello¥nWorld!'
    end
    it 'delete nothing' do
      str = 'Hello¥nWorld!¥n'
      expect(str.chomp).to eq 'Hello¥nWorld!¥n'
    end
  end

  describe 'reverse' do
    it 'reverse' do
      expect(str.reverse).to eq 'edcba'
      expect(str).to eq 'abcde'
    end
  end

  describe 'include?' do
    it 'should be true' do
      expect(str.include?('a')).to be true
    end
    it 'should be false' do
      expect(str.include?('x')).to be false
    end
  end

  describe 'hex' do
    it 'returns Fixnum, and 16' do
      expect("0x10".hex.class).to eq Fixnum
      expect("0x10".hex).to eq 16
    end
  end
end
