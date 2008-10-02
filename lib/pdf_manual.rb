class PdfManual
  include DataMapper::Resource
  property :id, Serial, :key => true
  property :filename, String
  property :content_type, String
  property :link, Text
  property :entry_system_id, Integer
  
  belongs_to :entry_system

  def data=(tmp_file)
    Thread.new do
      File.open(File.join(File.dirname(__FILE__), *%W[public pdfs #{self.filename}]), 'w') {|f| f.write tmp_file.read}
    end
  end
  
  def destroy
    FileUtils.rm_rf(File.join(File.dirname(__FILE__), *%W[public pdfs #{self.filename}]))
    super
  end
end
