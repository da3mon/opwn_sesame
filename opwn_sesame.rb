%w(rubygems sinatra dm-core dm-validations).each { |f| require f }

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
  property :filename, String, :nullable => false
  property :content_type, String, :nullable => false
  
  belongs_to :entry_system
end

class PdfManual
  include DataMapper::Resource
  property :id, Serial, :key => true
  property :filename, String, :nullable => false
  property :content_type, String, :nullable => false
  
  belongs_to :entry_system
end

configure do
  DataMapper.setup(:default, 'sqlite3::memory')
  EntrySystem.auto_migrate!
end

layout 'layout.erb'

get '/' do
  @entry_systems = EntrySystem.all
  erb :index
end

get '/entry_systems/new' do
  @entry_system = EntrySystem.new
  erb :new
end

get '/entry_systems/:id' do
  @entry_system = EntrySystem.get(params[:id])
  erb :show
end

get '/entry_systems/:id/edit' do
  @entry_system = EntrySystem.get(params[:id])
  erb :edit
end

post '/entry_systems' do
  @entry_system = EntrySystem.new(
    :name => params[:name],
    :manufacturer => params[:manufacturer],
    :prompt => params[:prompt],
    :password => params[:password]
  )
  if @entry_system.save
    redirect "/"
  else
    @errors = @entry_system.errors.full_messages.join("<br />")
    erb :new
  end
end

put '/entry_systems/:id' do
  @entry_system = EntrySystem.get(params[:id])
  if @entry_system.update_attributes(
    :name => params[:name],
    :manufacturer => params[:manufacturer],
    :prompt => params[:prompt],
    :password => params[:password]
  )
    redirect "/entry_systems/#{@entry_system.id}"
  else
    @errors = @entry_system.errors.full_messages.join("<br />")
    erb :edit
  end
end

delete '/entry_systems/:id' do
  EntrySystem.get(params[:id]).destroy
end