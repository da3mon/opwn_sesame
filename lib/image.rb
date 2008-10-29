require "RMagick"

class Image
  include DataMapper::Resource
  include FileAttachment

  property :id, Serial, :key => true
  property :filename, String, :nullable => false
  property :entry_system_id, Integer

  def initialize(attrs={})
    self.data = attrs.delete(:data) if attrs[:data]
    super
  end

  def extension
    'png'
  end
  
  protected
  def directory
    'images'
  end
  
  def save_file_type
    image = Magick::Image.from_blob(data).first
    image.change_geometry!("240x190") {|c, r| image.thumbnail!(c, r)}
    image.write(file_path)
  end
end
