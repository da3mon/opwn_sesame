%w(rubygems sinatra dm-core dm-validations).each { |f| require f }

class EntrySystem
  include DataMapper::Resource
  property :id, Serial, :key => true
  property :name, String, :nullable => false
  property :manufacturer, String, :nullable => false
  property :prompt, String
  property :password, String
  
  has 1, :image
  has 1, :pdf_manual
end

class Image
  include DataMapper::Resource
  property :id, Serial, :key => true
  property :filename, String, :nullable => false
  property :content_type, String, :nullable => false
  property :entry_system_id, Integer

  belongs_to :entry_system
  
  def data=(tmp_file)
    p tmp_file.read
    Thread.new do
      File.open(File.join(File.dirname(__FILE__), *%W[public images #{@entry_system.name}]), 'w') {|f| f << tmp_file.read}
      tmp_file.close
    end
  end
  
  def destroy
    FileUtils.rm_rf(File.join(File.dirname(__FILE__), *%W[public images #{self.entry_system.name}]))
    super
  end
end

class PdfManual
  include DataMapper::Resource
  property :id, Serial, :key => true
  property :filename, String, :nullable => false
  property :content_type, String, :nullable => false
  property :link, String
  
  property :entry_system_id, Integer
  
  belongs_to :entry_system
end

configure do
  DataMapper.setup(:default, 'sqlite3::memory')
  EntrySystem.auto_migrate!
  Image.auto_migrate!
  PdfManual.auto_migrate!
end

layout 'layout.erb'

get '/' do
  @entry_systems = EntrySystem.all
  erb :entry_systems_index
end

get '/entry_systems/new' do
  @entry_system = EntrySystem.new
  erb :entry_systems_new
end

get '/entry_systems/:id/image/new' do
  @entry_system = EntrySystem.get(params[:id])
  redirect "/entry_systems/new" unless @entry_system
  @image = Image.new
  erb :images_new
end

get '/entry_systems/:id/image' do
  @entry_system = EntrySystem.get(params[:id])
  p @entry_system.methods.sort
  @image = @entry_system.image
  erb :images_index
end

get '/entry_systems/:id' do
  @entry_system = EntrySystem.get(params[:id])
  redirect "/" unless @entry_system
  erb :entry_systems_show
end

get '/entry_systems/:id/edit' do
  @entry_system = EntrySystem.get(params[:id])
  erb :entry_systems_edit
end

post '/entry_systems' do
  @entry_system = EntrySystem.new(params)
  if @entry_system.save
    redirect "/"
  else
    erb :entry_systems_new
  end
end

post '/entry_systems/:id/image' do
  @entry_system = EntrySystem.get(params[:id])
  redirect "/entry_systems/new" unless @entry_system
  @image = Image.new(:filename => @entry_system.name.gsub(/\W/, '_'), :content_type => params[:image][:type], :data => params[:image][:tempfile])
  if @image.save
    @entry_system.image = @image
    @entry_system.save
    p params
    redirect "/entry_systems/#{@entry_system.id}"
  else
    erb :images_new
  end
end

put '/entry_systems/:id' do
  @entry_system = EntrySystem.get(params[:id])
  attributes = params.dup
  attributes.delete(:id)
  @entry_system.update_attributes(attributes)
  redirect "/entry_systems/#{@entry_system.id}"
end

delete '/entry_systems/:id' do
  EntrySystem.get(params[:id]).destroy
  redirect "/"
end

delete '/entry_systems/:id/image' do
  @entry_system = EntrySystem.get(params[:id])
  redirect "/" unless @entry_system
  @entry_system.image.destroy if @entry_system.image
  redirect "/entry_systems/#{@entry_system.id}"
end