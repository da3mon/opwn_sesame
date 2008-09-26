%w(rubygems sinatra dm-core).each { |f| require f }

class EntrySystem
  include DataMapper::Resource
  property :id, Serial, :key => true
  property :name, String, :nullable => false
  property :manufacturer, String, :nullable => false
  property :prompt, String
  property :password, String
  
  has n, :images
  has n, :pdf_manuals
end

class Image
  include DataMapper::Resource
  property :id, Serial, :key => true
end

class PdfManual
  include DataMapper::Resource
  property :id, Serial, :key => true
end

configure do
  DataMapper.setup(:default, 'sqlite3::memory')
  EntrySystem.auto_migrate!
end

layout 'layout.erb'

get '/' do
  @entry_systems = EntrySystem.all
  erb :index, :views_directory => File.dirname(__FILE__) + "/views/entry_systems"
end

get '/entry_systems/new' do
  @entry_system = EntrySystem.new
  erb :new, :views_directory => File.dirname(__FILE__) + "/views/entry_systems"
end

get '/entry_systems/:id' do
  @entry_system = EntrySystem.get!(params[:id])
  erb :show, :views_directory => File.dirname(__FILE__) + "/views/entry_systems"
end

post '/entry_systems' do
  @entry_system = EntrySystem.create!(
    :name => params[:name],
    :manufacturer => params[:manufacturer],
    :prompt => params[:prompt],
    :password => params[:password]
  )
  redirect "/"
end

put '/entry_systems/:id' do
  @entry_system = EntrySystem.find(:id).update_attributes(
    :name => params[:name],
    :manufacturer => params[:manufacturer],
    :prompt => params[:prompt],
    :password => params[:password]
  )
  redirect "/entry_systems/#{@entry_system.id}"
end