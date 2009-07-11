describe ReadRuby::Signature, ".new" do
  it "requires a Class as the first argument" do
    lambda do
      ReadRuby::Signature.new(String, :[], 'text') 
    end.should_not raise_error

    lambda do
      ReadRuby::Signature.new('string', :[], 'text') 
    end.should raise_error(ArgumentError)
  end

  it "requires a Symbol as the second argument" do
    lambda do
      ReadRuby::Signature.new(Array, :size, 'text') 
    end.should_not raise_error

    lambda do
      ReadRuby::Signature.new(File, [], 'text') 
    end.should raise_error(ArgumentError)
  end

  it "raises a NoMethodError if the given object has the given method" do
    lambda do
      ReadRuby::Signature.new(File, :glark, 'text') 
    end.should raise_error(NoMethodError)
  end

  it "doesn't raise a NoMethodError if the given object has the given instance method" do
    lambda do
      ReadRuby::Signature.new(File, :path, 'text') 
    end.should_not raise_error(NoMethodError)
  end

  it "doesn't raise a NoMethodError if the given object has the given class method" do
    lambda do
      ReadRuby::Signature.new(File, :open, 'text') 
    end.should_not raise_error(NoMethodError)
  end

  it "requires a String for the final argument" do
    lambda do
      ReadRuby::Signature.new(File, :size, 'text') 
    end.should_not raise_error

    lambda do
      ReadRuby::Signature.new(File, :open, :size) 
    end.should raise_error(ArgumentError)
  end

  it "returns an instance of ReadRuby::Signature" do
    ReadRuby::Signature.new(Array, :size, 'foo').should 
      be_an_instance_of(ReadRuby::Signature)
  end
end

describe ReadRuby::Signature, "#object" do
  it "returns a Class" do
    ReadRuby::Signature.new(Array, :first, 'text').object.should 
      be_an_instance_of(Class)
  end

  it "returns the first argument passed to the constructor" do
    ReadRuby::Signature.new(Array, :first, 'text').object.should == Array
  end
end

describe ReadRuby::Signature, "#method" do
  it "returns a Symbol" do
    ReadRuby::Signature.new(Array, :first, 'text').method.should 
      be_an_instance_of(Symbol)
  end

  it "returns the second argument passed to the constructor" do
    ReadRuby::Signature.new(Array, :first, 'text').method.should == :first
  end
end

describe ReadRuby::Signature, "#returns" do
  it "returns an Array" do
    ReadRuby::Signature.new(Array, :first, 'text').returns.should 
      be_an_instance_of(Array)
  end

  it "returns an Array of Class objects if return types were specified" do
    ReadRuby::Signature.new(Array, :first, '    () => Object').returns.
      all? {|o| o.should be_a_kind_of(Class) }
  end

  it "returns the return value specified in the signature" do
    ReadRuby::Signature.new(Array, :first, '    () => Object').
      returns.should == [Object]
  end

  it "understands signatures with paramater types" do
    ReadRuby::Signature.new(String, :slice, '    (Fixnum offset) => String').
      returns.should == [String]
  end

  it "ignores leading whitespace" do
    ReadRuby::Signature.new(Array, :first, '    () =>    Object').
      returns.should == [Object]
  end

  it "ignores trailing whitespace" do
    ReadRuby::Signature.new(Array, :first, '    () => Object   ').
      returns.should == [Object]
  end

  it "recognises multiple return types separated by ' or '" do
    ReadRuby::Signature.new(Array, :first, '    () => Object or NilClass').
      returns.should == [Object, NilClass]
  end

  it "recognises multiple return types separated by ', '" do
    ReadRuby::Signature.new(Array, :first, '    () => Object, NilClass').
      returns.should == [Object, NilClass]
  end

  it "recognises multiple return types separated by ' '" do
    ReadRuby::Signature.new(Array, :first, '    () => Object  NilClass').
      returns.should == [Object, NilClass]
  end

  it "raises a NameError if the return type is not a valid constant" do
    lambda do
      ReadRuby::Signature.new(Array, :first, '    () => Objectified').returns
    end.should raise_error(NameError)
  end

  it "raises a NameError if one return type is not a valid constant, but others are" do
    lambda do
      ReadRuby::Signature.new(
        Array, :first, '    () => Hash Objectified'
      ).returns
    end.should raise_error(NameError)
  end

  it "returns an empty Array when no signature was found" do
    ReadRuby::Signature.new(Array, :first, 'text').
      returns.should == []
  end
end
