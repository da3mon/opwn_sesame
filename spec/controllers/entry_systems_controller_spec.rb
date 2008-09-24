require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EntrySystemsController do
  describe "create" do
    xit "creates an entry_system" do
      post :create, :entry_system => {:name => 'name', :manufacturer => 'manufacturer'}
      response.should be_success
      
      es = EntrySystem.find_by_id(:order => :desc)
      es.should_not be_nil
      
      response.should redirect_to(entry_systems_path(es))
    end
  end

  describe "new" do
    it "renders the new template an entry_system" do
      get :new
      response.should be_success
      response.should render_template(:new)
      assigns[:entry_system].should be_new_record
    end
  end
end