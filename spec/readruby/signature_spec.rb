describe ReadRuby::Signature, ".new" do
  it "requires a String argument" do
    lambda do
      ReadRuby::Signature.new('text') 
    end.should_not raise_error

    lambda do
      ReadRuby::Signature.new(:size) 
    end.should raise_error(ArgumentError)
  end

  it "returns an instance of ReadRuby::Signature" do
    ReadRuby::Signature.new('foo').should 
      be_an_instance_of(ReadRuby::Signature)
  end
end

describe ReadRuby::Signature, "#returns" do
  it "returns an Array" do
    ReadRuby::Signature.new('text').returns.should 
      be_an_instance_of(Array)
  end

  it "returns an Array of Class objects if return types were specified" do
    ReadRuby::Signature.new('    () => Object').returns.
      all? {|o| o.should be_a_kind_of(Class) }
  end

  it "returns the return value specified in the signature" do
    ReadRuby::Signature.new('    () => Object').
      returns.should == [Object]
  end

  it "understands signatures with paramater types" do
    ReadRuby::Signature.new('    (Fixnum offset) => String').
      returns.should == [String]
  end

  it "ignores leading whitespace" do
    ReadRuby::Signature.new('    () =>    Object').
      returns.should == [Object]
  end

  it "ignores trailing whitespace" do
    ReadRuby::Signature.new('    () => Object   ').
      returns.should == [Object]
  end

  it "recognises multiple return types separated by ' or '" do
    ReadRuby::Signature.new('    () => Object or NilClass').
      returns.should == [Object, NilClass]
  end

  it "recognises multiple return types separated by ', '" do
    ReadRuby::Signature.new('    () => Object, NilClass').
      returns.should == [Object, NilClass]
  end

  it "recognises multiple return types separated by ' '" do
    ReadRuby::Signature.new('    () => Object  NilClass').
      returns.should == [Object, NilClass]
  end

  it "accepts a return value of 'self'" do
    ReadRuby::Signature.new('    () => self').returns.should == ['self']
  end

  it "accepts a return value of 'true'" do
    ReadRuby::Signature.new('    () => true').returns.should == ['true']
  end

  it "accepts a return value of 'false'" do
    ReadRuby::Signature.new('    () => false').returns.should == ['false']
  end

  it "accepts a return value of 'nil'" do
    ReadRuby::Signature.new('    () => nil').returns.should == ['nil']
  end
  
  it "raises a NameError if the return type is not a valid constant" do
    lambda do
      ReadRuby::Signature.new('    () => Objectified').returns
    end.should raise_error(NameError)
  end

  it "raises a NameError if one return type is not a valid constant, but others are" do
    lambda do
      ReadRuby::Signature.new('    () => Hash Objectified').returns
    end.should raise_error(NameError)
  end

  it "returns an empty Array when no signature was found" do
    ReadRuby::Signature.new('text').
      returns.should == []
  end
end

describe ReadRuby::Signature, "#signature" do
  it "returns an Array" do
    ReadRuby::Signature.new('text').signature.should 
      be_an_instance_of(Array)
  end

  it "returns each signature element as a sub-Array" do
    ReadRuby::Signature.new('    (Fixnum) => Object').signature.
      all? {|o| o.should be_a_kind_of(Array) }
  end

  it "sets first element of each sub-Array to a Class if types were specified" do
    ReadRuby::Signature.new('    (Fixnum) => Object').signature.
      all? {|a| a.first.should be_a_kind_of(Class) }
  end

  it "sets last element of each sub-Array to a Symbol if paramater names were specified" do
    ReadRuby::Signature.new('    (Fixnum offset) => Object').signature.
      all? {|a| a.last.should be_a_kind_of(Symbol) }
  end

  it "returns the single type specified in the signature" do
    ReadRuby::Signature.new('    (Fixnum) => Object').
      signature.should == [[Fixnum]]
  end

  it "returns the types specified in the signature" do
    ReadRuby::Signature.new('    (Fixnum, String) => Object').
      signature.should == [[Fixnum], [String]]
  end

  it "returns the single type-paramater pair specified in the signature" do
    ReadRuby::Signature.new('    (Fixnum index) => Object').
      signature.should == [[Fixnum, :index]]
  end

  it "returns the type-paramater pairs specified in the signature" do
    ReadRuby::Signature.new('    (Fixnum index, String name) => Object').
      signature.should == [[Fixnum, :index], [String, :name]]
  end

  it "returns [[]] when no signature is given" do
    ReadRuby::Signature.new('    () =>    Object').
      signature.should == [[]]
  end

  it "ignores leading whitespace" do
    ReadRuby::Signature.new('           (Fixnum) => Object').
      signature.should == [[Fixnum]]
  end

  it "ignores trailing whitespace" do
    ReadRuby::Signature.new('    (Fixnum)                 => Object').
      signature.should == [[Fixnum]]
  end

  it "allows types to be separated by ', '" do
    ReadRuby::Signature.new('    (Fixnum, String) => Object or NilClass').
      signature.should == [[Fixnum], [String]]
  end

  it "allows type-paramater pairs to be separated by ', '" do
    ReadRuby::Signature.new('    (Fixnum index, String) => Object or NilClass').
      signature.should == [[Fixnum, :index], [String]]
  end

  it "recognises types separated by ' '" do
    ReadRuby::Signature.new('    (Fixnum Float Integer) => Object  NilClass').
      signature.should == [[Fixnum], [Float], [Integer]]
  end

  it "recognises type-paramater pairs separated by ' '" do
    ReadRuby::Signature.new('    (Float glark Integer bar) => Object or NilClass').
      signature.should == [[Float, :glark], [Integer, :bar]]
  end

  it "raises a NameError if a type is not a valid constant" do
    lambda do
      ReadRuby::Signature.new('    (Floating) => Object').signature
    end.should raise_error(NameError)
  end

  it "raises a NameError if one type is not a valid constant, but others are" do
    lambda do
      ReadRuby::Signature.new(
        '    (Integer, Filed file) => Hash Object').signature
    end.should raise_error(NameError)
  end

  it "accepts signatures with block arguments" do
    lambda do
      ReadRuby::Signature.new(
        '    (Integer, File file) { |var| } => Hash Object').signature
    end.should_not raise_error
  end

  it "sets the last element of the Array to the signature block argument" do
      ReadRuby::Signature.new(
        '    (Integer, File file) { |var| } => Hash Object'
      ).signature.last.should == ['{ |var| }']
  end
end

describe ReadRuby::Signature, "#to_s" do
  before(:each) do
    @string_slice = ReadRuby::Signature.new(
      '    (Fixnum index) => String or NilClass').to_s
  end

  it "returns a String" do
    @string_slice.should be_an_instance_of(String)
  end

 it "includes the signature" do
    @string_slice.should =~ /Fixnum index/
 end

 it "includes the return value" do
   @string_slice.should =~ /String or NilClass/
 end

 it "displays a block argument after the closing parenthesis" do
    ReadRuby::Signature.new(
      '    (Fixnum index) { |var| } => String or NilClass'
    ).to_s.should include(') { |var| }')
 end
end 

describe ReadRuby::Signature, "#ok?" do

  it "returns true if the signature contains only valid constants" do
    ReadRuby::Signature.new(
      '    (Fixnum index) => String'
    ).ok?.should be_true
  end

  it "returns true if the signature is empty" do
    ReadRuby::Signature.new(
      '    () => String'
    ).ok?.should be_true
  end

  it "returns false if the signature contains invalid constants" do
    ReadRuby::Signature.new(
      '    (FixUp index) => String'
    ).ok?.should be_false
  end

  it "returns false if the signature contains duplicate paramater names" do
    ReadRuby::Signature.new(
      '    (Fixnum index, String index) => String or NilClass'
    ).ok?.should be_false
  end

  it "returns true if the return contains only valid constants" do
    ReadRuby::Signature.new(
      '    (Fixnum index) => String or NilClass'
    ).ok?.should be_true
  end

  it "returns false if the return contains invalid constants" do
    ReadRuby::Signature.new(
      '    (Fixnum index) => String or Nilz'
    ).ok?.should be_false
  end

  it "returns false if the return and the signature contain invalid constants" do
    ReadRuby::Signature.new(
      '    (Fixnumz index) => String or Nilz'
    ).ok?.should be_false
  end
end 
