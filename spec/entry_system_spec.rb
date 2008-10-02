require File.join(File.dirname(__FILE__), *%w[spec_helper])

describe EntrySystem do
  attr_reader :attrs
  before(:each) do
    @attrs = {:name => "name", :manufacturer => "manufacturer"}
  end
  
  describe "validations" do
    it "requires a name" do
      es = EntrySystem.new(attrs.drop(:name))
      es.should_not be_valid
    end
    
    it "requires a manufacturer" do
      es = EntrySystem.new(attrs.drop(:manufacturer))
      es.should_not be_valid
    end
    
    it "is valid when both are provided" do
      lambda { EntrySystem.create(attrs) }.should_not raise_error
    end
    
    it "errors on bogus attrs" do
      lambda { EntrySystem.create(attrs.merge(:bogus => "bogus")) }.should raise_error(NameError)
    end
  end
end