doc(String, :size, 'Returns the size of _self_')
describe "String#size" do
  it "returns a Fixnum" do
    ''.size.should be_an_instance_of(Fixnum)
  end
end
