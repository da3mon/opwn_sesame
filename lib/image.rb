require "RMagick"

class Image
  include DataMapper::Resource
  property :id, Serial, :key => true
  property :filename, String, :nullable => false
  property :link, String, :length => 0..255
  property :entry_system_id, Integer

  belongs_to :entry_system
  
  before :save, :save_file
  before :destroy, :delete_file
  
  attr_reader :image_path
    
  def initialize(attrs)
    @data = attrs.delete(:data) if attrs[:data]
    super
  end
    
  protected
  def save_file
    return unless @data
    Thread.new do
      image = Magick::Image.from_blob(@data.read).first
      image.change_geometry!("80x170") { |cols, rows| image.thumbnail! cols, rows }
      image.write(image_path)
    end.join
  end
  
  def default_filename
    self.filename = attributes[:filename]
  end
  
  def image_path
    @image_path ||= File.join(File.dirname(__FILE__), *%W[.. public images #{self.filename}.png])
  end

  def delete_file
    Thread.new { FileUtils.rm_rf image_path }.join
  end
end
