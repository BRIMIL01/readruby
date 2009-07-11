describe ReadRuby::Invocation, ".new" do
  it "requires a Class as the first argument" do
    lambda do
      ReadRuby::Invocation.new(String, :[], 'text') 
    end.should_not raise_error

    lambda do
      ReadRuby::Invocation.new('string', :[], 'text') 
    end.should raise_error(ArgumentError)
  end

  it "requires a Symbol as the second argument" do
    lambda do
      ReadRuby::Invocation.new(Array, :size, 'text') 
    end.should_not raise_error

    lambda do
      ReadRuby::Invocation.new(File, [], 'text') 
    end.should raise_error(ArgumentError)
  end

  it "raises a NoMethodError if the given object doesn't have the given method" do
    lambda do
      ReadRuby::Invocation.new(File, :glark, 'text') 
    end.should raise_error(NoMethodError)
  end

  it "doesn't raise a NoMethodError if the given object has the given instance method" do
    lambda do
      ReadRuby::Invocation.new(File, :path, 'text') 
    end.should_not raise_error(NoMethodError)
  end

  it "doesn't raise a NoMethodError if the given object has the given class method" do
    lambda do
      ReadRuby::Invocation.new(File, :open, 'text') 
    end.should_not raise_error(NoMethodError)
  end

  it "requires a String for the final argument" do
    lambda do
      ReadRuby::Invocation.new(File, :size, 'text') 
    end.should_not raise_error

    lambda do
      ReadRuby::Invocation.new(File, :open, :size) 
    end.should raise_error(ArgumentError)
  end

  it "returns an instance of ReadRuby::Invocation" do
    ReadRuby::Invocation.new(Array, :size, 'foo').should 
      be_an_instance_of(ReadRuby::Invocation)
  end
end

describe ReadRuby::Invocation, "#object" do
  it "returns a Class" do
    ReadRuby::Invocation.new(Array, :first, 'text').object.should 
      be_an_instance_of(Class)
  end

  it "returns the first argument passed to the constructor" do
    ReadRuby::Invocation.new(Array, :first, 'text').object.should == Array
  end
end

describe ReadRuby::Invocation, "#method" do
  it "returns a Symbol" do
    ReadRuby::Invocation.new(Array, :first, 'text').method.should 
      be_an_instance_of(Symbol)
  end

  it "returns the second argument passed to the constructor" do
    ReadRuby::Invocation.new(Array, :first, 'text').method.should == :first
  end
end

# TODO it_behaves_like
describe ReadRuby::Invocation, "#returns" do
  it "returns an Array object" do
    ReadRuby::Invocation.new(
      Array, :first, '    () => Object or NilClass'
    ).returns.should be_an_instance_of(Array)
  end
end

# TODO it_behaves_like
describe ReadRuby::Invocation, "#signature" do
  it "returns an Array object" do
    ReadRuby::Invocation.new(
      Array, :at, '    (Fixnum index) => Object or NilClass'
                            ).signature.should be_an_instance_of(Array)
  end
end

describe ReadRuby::Invocation, "#idescription" do
  it "returns a String" do
    ReadRuby::Invocation.new(Array, :first, 'text').description.should 
      be_an_instance_of(String)
  end

  it "returns the last argument passed to the constructor" do
    ReadRuby::Invocation.new(Array, :first, 'text').description.should == 'text'
  end
end
