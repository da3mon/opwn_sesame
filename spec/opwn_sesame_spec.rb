%w(rubygems spec sinatra sinatra/test/rspec).each { |f| require f }

describe "opwn_sesame" do
  require "opwn_sesame"
  attr_reader :response
  
  it "/ gets a list of entry systems" do
    get_it '/'
    response.should be_ok
  end
  
  it "gets /entry_systems/new" do
    get_it '/entry_systems/new'
    response.should be_ok
  end
end