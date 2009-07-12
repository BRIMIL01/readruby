describe ReadRuby::Runner, ".process_file" do
  before(:each) do
    ReadRuby::Runner.reset!
  end

  it "requires a filename as an argument" do
    lambda do
      ReadRuby::Runner.process_file(fixture('simple.rb')) 
    end.should_not raise_error(ArgumentError)
  end

  it "stores each invocation object it generates" do
    ReadRuby::Runner.process_file(fixture('simple.rb')) 
    ReadRuby::Runner.fetch.first.method.should == :size
  end

  it "understands files that contain multiple calls to #doc" do
    ReadRuby::Runner.process_file(fixture('two_in_one_file.rb')) 
    ReadRuby::Runner.fetch.first.method.should == :size
    ReadRuby::Runner.fetch.last.method.should == :abs
  end

  it "understands #doc calls for methods with aliases" do
    ReadRuby::Runner.process_file(fixture('aliased_method.rb')) 
    ReadRuby::Runner.fetch.first.method.should == :slice
    ReadRuby::Runner.fetch.last.method.should == :[]
  end

  it "maintains state over multiple files" do
    ReadRuby::Runner.process_file(fixture('simple.rb')) 
    ReadRuby::Runner.process_file(fixture('aliased_method.rb')) 
    ReadRuby::Runner.fetch[0].method.should == :size
    ReadRuby::Runner.fetch[1].method.should == :slice
    ReadRuby::Runner.fetch[2].method.should == :[]
  end

  it "ignores `describe` blocks" do
    lambda do
      ReadRuby::Runner.process_file(fixture('simple_with_describe.rb'))
    end.should_not raise_error 
    ReadRuby::Runner.fetch[0].method.should == :size
  end

  it "ignores `describe` blocks containing `it` blocks" do
    lambda do
      ReadRuby::Runner.process_file(fixture('simple_with_describe_it.rb'))
    end.should_not raise_error 
    ReadRuby::Runner.fetch[0].method.should == :size
  end

  it "ignores `ruby_version_is` blocks" do
    lambda do
      ReadRuby::Runner.process_file(fixture('simple_with_ruby_version_is.rb'))
    end.should_not raise_error 
    ReadRuby::Runner.fetch[0].method.should == :size
  end
end
