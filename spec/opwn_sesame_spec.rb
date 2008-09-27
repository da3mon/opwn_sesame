%w(rubygems spec sinatra sinatra/test/rspec).each { |f| require f }

describe "opwn_sesame" do
  require "opwn_sesame"
  attr_reader :response, :ivars
  before(:each) do
    EntrySystem.all.should == []
  end
  
  after(:each) do
    EntrySystem.all.destroy!
  end
  
  it "/ gets a list of entry systems" do
    es = EntrySystem.create(:name => "name", :manufacturer => "manufacturer")
    
    get_it '/'
    response.should be_ok
    body.should include(es.name)
    body.should include(es.manufacturer)
  end
  
  it "gets /entry_systems/new" do
    get_it '/entry_systems/new'
    response.should be_ok
    body.should =~ /method="post"/
    body.should =~ /action="\/entry_systems"/
  end
  
  describe "entry_system creation" do
    attr_reader :params
    before(:each) do
      @params = {:name => "name", :manufacturer => "manufacturer"}
    end

    context "with valid params" do
      it "creates the entry_system and redirects" do      
        post_it "/entry_systems", :name => params[:name], :manufacturer => params[:manufacturer]

        p response
        p body

        response.should be_redirection
        follow!

        body.should include("name")
        body.should include("manufacturer")
      end
    end
    
    context "with invalid params" do
      it "creates entry systems" do      
        post_it "/entry_systems", :manufacturer => params[:manufacturer]
        response.should be_ok

        body.should_not include("name")
        body.should_not include("manufacturer")
      end
    end
  end
end