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
end

describe ReadRuby::Signature, "#format" do
  it "requires a Class as the first argument" do
    lambda do
      ReadRuby::Signature.new('text').format(String, :size)
    end.should_not raise_error(ArgumentError)

    lambda do
      ReadRuby::Signature.new('text').format('', :size)
    end.should raise_error(ArgumentError)
  end

  it "requires a Symbol as the second argument" do
    lambda do
      ReadRuby::Signature.new('text').format(String, :size)
    end.should_not raise_error(ArgumentError)

    lambda do
      ReadRuby::Signature.new('text').format(String, 0)
    end.should raise_error(ArgumentError)
  end

  it "returns a String" do
    ReadRuby::Signature.new('text').format(String, :size).should 
      be_an_instance_of(String)
  end

  it "includes the Class name" do
    ReadRuby::Signature.new('text').format(String, :size).should =~ /\WString\W/
  end 

  it "includes the method name" do
    ReadRuby::Signature.new('text').format(String, :size).should =~ /\Wsize\W/
  end

 it "includes the signature" do
    ReadRuby::Signature.new('    (Fixnum index, String other) => String').
      format(String, :insert).should =~ /\(Fixnum index, String other\)/
 end

 it "includes the return value" do
    ReadRuby::Signature.new('    (Fixnum index, String other) => String').
      format(String, :insert).should =~ / => String/
 end
end 
