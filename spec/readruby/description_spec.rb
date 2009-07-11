describe ReadRuby::Description, ".new" do
  it "requires a String argument" do
    lambda do
      ReadRuby::Description.new('text') 
    end.should_not raise_error(ArgumentError)
  end

  it "does not accept additional arguments" do
    lambda do
      ReadRuby::Description.new('text', 'foo') 
    end.should raise_error(ArgumentError)
  end

  it "raises an ArgumentError if not given a String" do
    lambda do
      ReadRuby::Description.new(:text) 
    end.should raise_error(ArgumentError)
  end
end

describe ReadRuby::Description, "#text" do
  it "returns the constructor argument" do
    ReadRuby::Description.new('text').text.should == 'text'
  end

  it "returns a String" do
    ReadRuby::Description.new('text').text.should be_an_instance_of(String)
  end
end

describe ReadRuby::Description, "#html" do
  it "interprets the constructor argument as Markdown and returns it as HTML" do
    ReadRuby::Description.new('*text*').html.should == "<p><em>text</em></p>"
  end

  it "returns a String" do
    ReadRuby::Description.new('*text*').html.should be_an_instance_of(String)
  end
end
