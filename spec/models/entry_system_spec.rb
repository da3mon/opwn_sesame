require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EntrySystem do
  attr_reader :valid_attributes
  before(:each) do
    @valid_attributes = {
      :name => 'name',
      :manufacturer => 'manufacturer'
    }
  end

  describe "Validations" do
    it "is valid with a name and manufacturer only" do
      lambda do 
        es = EntrySystem.create!(valid_attributes)
        es.should be_valid
      end.should_not raise_error(ActiveRecord::RecordInvalid)
    end

    it "is invalid without a name" do
      es = EntrySystem.new({:manufacturer => 'manufacturer'})
      es.should_not be_valid
    end

    it "is invalid without a manufacturer" do
      es = EntrySystem.new({:name => 'name'})
      es.should_not be_valid
    end
  end
end
