%w(rubygems sinatra dm-core dm-validations fileutils do_sqlite3).each { |f| require f }
Dir[File.join(File.dirname(__FILE__), *%w[lib *])].each { |f| require f }

configure do
  DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}entry_systems.db")
  DataMapper.auto_migrate!
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

get '/entry_systems/:id/pdf_manual/new' do
  @entry_system = EntrySystem.get(params[:id])
  redirect "/entry_systems/new" unless @entry_system
  @pdf_manual = PdfManual.new
  erb :pdf_manuals_new
end

get '/entry_systems/:id/pdf_manual' do
  @entry_system = EntrySystem.get(params[:id])
  send_file(File.join(File.dirname(__FILE__), *%W[public pdfs #{@entry_system.pdf_manual.filename}]), :type => "application/pdf", :filename => "#{@entry_system.pdf_manual.filename}.pdf")
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
  @image = Image.new(
    :filename => @entry_system.name.gsub(/\W/, '_'),
    :data => params[:image][:tempfile].read
  )
  if @image.save
    @entry_system.image = @image
    @entry_system.save
    redirect "/entry_systems/#{@entry_system.id}"
  else
    erb :images_new
  end
end

post '/entry_systems/:id/pdf_manual' do
  @entry_system = EntrySystem.get(params[:id])
  redirect "/entry_systems/new" unless @entry_system
  @pdf_manual = PdfManual.new(
    :link => params[:link],
    :filename => @entry_system.name.gsub(/\W/, '_'),
    :data => params[:pdf_manual][:tempfile]
  )
  if @pdf_manual.save
    @entry_system.pdf_manual = @pdf_manual
    @entry_system.save
    redirect "/entry_systems/#{@entry_system.id}"
  else
    erb :pdf_manuals_new
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
  es = EntrySystem.get(params[:id])
  es.image.destroy if es.image
  es.pdf_manual.destroy if es.pdf_manual
  es.destroy
  redirect "/"
end

delete '/entry_systems/:id/image' do
  @entry_system = EntrySystem.get(params[:id])
  redirect "/" unless @entry_system
  @entry_system.image.destroy if @entry_system.image
  @entry_system.pdf_manual.destroy if @entry_system.pdf_manual
  redirect "/entry_systems/#{@entry_system.id}"
end

delete '/entry_systems/:id/pdf_manual' do
  @entry_system = EntrySystem.get(params[:id])
  redirect "/" unless @entry_system
  @entry_system.pdf_manual.destroy if @entry_system.pdf_manual
  redirect "/entry_systems/#{@entry_system.id}"
end