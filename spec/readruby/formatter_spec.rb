describe ReadRuby::Formatter, ".new" do
  before(:each) do
    @invocation = ReadRuby::Invocation.new(
      String, :[], 'Description...')
  end

  it "requires an Invocation object as its argument" do
    lambda do
      ReadRuby::Formatter.new(@invocation) 
    end.should_not raise_error(ArgumentError)
  end

  it "does not accept additional arguments" do
    lambda do
      ReadRuby::Formatter.new(@invocation, 'foo') 
    end.should raise_error(ArgumentError)
  end

  it "raises an ArgumentError if not given an Invocation object" do
    lambda do
      ReadRuby::Formatter.new(:text) 
    end.should raise_error(ArgumentError)
  end
end

describe ReadRuby::Formatter, "#text" do
  before(:each) do
    @invocation = ReadRuby::Invocation.new(
      String, :[], "    (Fixnum offset) => String or NilClass\nDescription...")
  end

  it "returns a String" do
    ReadRuby::Formatter.new(@invocation).text.should be_an_instance_of(String)
  end

  it "includes the class name" do
    ReadRuby::Formatter.new(@invocation).text.should =~ /\WString\W/
  end

  it "includes the method name" do
    ReadRuby::Formatter.new(@invocation).text.should =~ /\W\[\]\W/
  end

  it "includes the description" do
    ReadRuby::Formatter.new(@invocation).text.should =~ /Description/
  end

  it "includes the examples"
  it "doesn't include HTML tags"
end

describe ReadRuby::Formatter, "#html" do
  before(:each) do
    @invocation = ReadRuby::Invocation.new(
      String, :[], "    (Fixnum offset) => String or NilClass\nDescription of `[]`")
  end

  it "returns a String" do
    ReadRuby::Formatter.new(@invocation).html.should be_an_instance_of(String)
  end

  it "includes the class name" do
    ReadRuby::Formatter.new(@invocation).html.should =~ /\WString\W/
  end

  it "includes the method name" do
    ReadRuby::Formatter.new(@invocation).html.should =~ /\W\[\]\W/
  end

  it "includes the description" do
    ReadRuby::Formatter.new(@invocation).html.should =~ /Description/
  end

  it "interprets the description as containing Markdown" do
    ReadRuby::Formatter.new(@invocation).html.should =~ /<code>\[\]<\/code>/
  end

  it "includes the examples"
  it "includes HTML tags"
end

