describe Object, "#doc" do
  it "requires a Class as the first argument" do
    lambda { doc(:Class, :sym, 'string') }.should raise_error(ArgumentError)
    lambda { doc(String, :size, 'str') }.should_not raise_error(ArgumentError)
  end

  it "requires a Symbol as the second argument" do
    lambda { doc(Fixnum, '+', 'string') }.should raise_error(ArgumentError)
    lambda { doc(Fixnum, :+, 'str') }.should_not raise_error(ArgumentError)
  end

  it "accepts Symbols as subsequent arguments" do
    lambda { doc(Fixnum, :+, '-', 's') }.should raise_error(ArgumentError)
    lambda { doc(Fixnum, :+, :-, 's') }.should_not raise_error(ArgumentError)
  end

  it "requires all Symbol names to be unique" do
    lambda { doc(Fixnum, :+, '+', 's') }.should raise_error(ArgumentError)
    lambda { doc(Fixnum, :+, '+', :-, 's') }.should raise_error(ArgumentError)
    lambda { doc(Fixnum, :+, :-, 's') }.should_not raise_error(ArgumentError)
  end

  it "requires a String as the final argument" do
    lambda { doc(Fixnum, :+, []) }.should raise_error(ArgumentError)
    lambda { doc(Fixnum, :+, :-, 's') }.should_not raise_error(ArgumentError)
  end

  it "returns an Array" do
    doc(Fixnum, :*, 's').should be_an_instance_of(Array)
  end

  it "returns an Array of Invocation objects" do
    doc(Fixnum, :*, 's').all? do |i| 
      i.should be_an_instance_of(ReadRuby::Invocation)
    end
  end

  it "returns as many Invocation objects as there are named methods" do
    doc(String, :slice, :[], 's').size.should == 2
  end

  it "returns the corresponding Symbol for each Invocation's #method method" do
    doc(String, :slice, :[], 's').first.method.should == :slice
    doc(String, :slice, :[], 's').last.method.should == :[]
  end
end
