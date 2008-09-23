require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EntrySystemsController do
  describe "create" do
    it "creates an entry_system" do
      post :create, :entry_system => {:name => 'name', :manufacturer => 'manufacturer'}
      response.should be_success
      
      es = EntrySystem.find_by_id(:order => :desc)
      es.should_not be_nil
      
      response.should redirect_to(entry_systems_path(es))
    end
  end
end