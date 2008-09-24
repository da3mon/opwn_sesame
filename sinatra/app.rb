%w(rubygems sinatra dm-core).each { |f| require f }

class EntrySystem
  include DataMapper::Resource
  
  property :id, Serial, :key => true
  property :name, String
  property :manufacturer, String
  property :prompt, String
  property :password, String
end

configure do
  DataMapper.setup(:default, 'sqlite3::memory')
  EntrySystem.auto_migrate!
end

get '/' do
  @entry_systems = EntrySystem.all
  erb :index
end

get '/entry_systems/:id' do
  @entry_system = EntrySystem.first :id => params[:id]
  erb :show
end

post '/entry_systems' do
  entry_system = EntrySystem.new \
    :name => params[:name],
    :manufacturer => params[:manufacturer],
    :prompt => params[:prompt],
    :password => params[:password]
  puts entry_system.inspect
  entry_system.save
  redirect "/entry_systems"
end

put '/entry_systems/:id' do
  entry_system = EntrySystem.find(:id).update_attributes(
    :name => params[:name],
    :manufacturer => params[:manufacturer],
    :prompt => params[:prompt],
    :password => params[:password]
  )
  puts entry_system.inspect
  entry_system.save
  redirect "/entry_systems/#{entry_system.id}"
end