require "RMagick"

class Image
  include DataMapper::Resource
  include FileAttachment

  property :id, Serial, :key => true
  property :filename, String, :nullable => false
  property :link, String, :length => 0..255
  property :entry_system_id, Integer

  def initialize(attrs)
    self.data = attrs.delete(:data) if attrs[:data]
    super
  end

  protected
  def extension
    'png'
  end
  
  def directory
    'images'
  end
  
  def save_file_type
    Thread.new do
      image = Magick::Image.from_blob(data.read).first
      image.change_geometry!("80x170") { |cols, rows| image.thumbnail! cols, rows }
      image.write(file_path)
    end
  end
end
