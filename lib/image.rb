class Image
  include DataMapper::Resource
  property :id, Serial, :key => true
  property :filename, String
  property :content_type, String
  property :link, String, :length => 0..255
  property :entry_system_id, Integer

  belongs_to :entry_system
  
  def data=(tmp_file)
    Thread.new do
      image = Magick::Image.from_blob(tmp_file.read).first
      image.change_geometry!("80x170") { |cols, rows| image.thumbnail! cols, rows }
      image.write(File.join(File.dirname(__FILE__), *%W[public images #{entry_system.filename}]))
    end
  end
  
  def destroy
    FileUtils.rm_rf(File.join(File.dirname(__FILE__), *%W[public images #{self.filename}]))
    super
  end
end
