describe ReadRuby::Example, ".new" do
  it "accepts a String argument" do
    lambda { ReadRuby::Example.new("1 + 2 #=> 3") }.should_not raise_error
  end

  it "returns a ReadRuby::Example instance" do
    ReadRuby::Example.new('1 + 2 #=> 3').should 
      be_an_instance_of(ReadRuby::Example)
  end

  it "accepts incorrectly formatted examples" do
    lambda { ReadRuby::Example.new("1 + 2") }.should_not raise_error
  end
end

describe ReadRuby::Example, "#expected" do
  it "returns a String" do
    ReadRuby::Example.new('1 + 2 #=> 3').expected.should 
      be_an_instance_of(String)
  end

  it "returns the expected output of the example" do
    ReadRuby::Example.new("1 + 2 #=> 3").expected.should == '3'
  end

  it "returns the expected output of the example even if it's not the actual output" do
    ReadRuby::Example.new("1 + 2 #=> 'e'").expected.should == '"e"'
  end

  it "normalises leading whitespace" do
    ReadRuby::Example.new('[].size #=>    0').expected.should == '0'
  end

  it "normalises trailing whitespace" do
    ReadRuby::Example.new('[].size #=> 0  ').expected.should == '0'
  end
end

describe ReadRuby::Example, "#given" do
  it "returns a String" do
    ReadRuby::Example.new('1 + 2 #=> 3').given.should be_an_instance_of(String)
  end

  it "returns the code that should evaluate to the expected output" do
    ReadRuby::Example.new("1 + 2 #=> 3").given.should == '1 + 2'
  end

  it "returns the given code even if it doesn't evaluate to the expected output" do
    ReadRuby::Example.new("1 + 2 #=> 'e'").given.should == '1 + 2'
  end

  it "normalises leading whitespace" do
    ReadRuby::Example.new('  [].size #=> 0').given.should == '[].size'
  end

  it "normalises trailing whitespace" do
    ReadRuby::Example.new('[].size   #=> 0  ').given.should == '[].size'
  end
end

describe ReadRuby::Example, "#actual" do
  it "returns a String" do
    ReadRuby::Example.new('1 + 2 #=> 3').actual.should be_an_instance_of(String)
  end

  it "returns the result of evaulating the given expression" do
    ReadRuby::Example.new('1 + 2 #=> 3').actual.should == '3'
  end

  it "works even if the actual output is different from the expected output" do
    ReadRuby::Example.new('2 + 2 #=> 3').actual.should == '4'
  end
end

describe ReadRuby::Example, "#ok?" do
  it "returns true if the expected output is equal to the actual output" do
    ReadRuby::Example.new('1 + 2 #=> 3').ok?.should be_true
  end

  it "returns false if the expected output is not equal to the actual output" do
    ReadRuby::Example.new('1 + 2 #=> 4').ok?.should be_false
  end
end
