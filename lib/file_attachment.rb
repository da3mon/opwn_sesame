module FileAttachment
  def self.included(including_class)
    including_class.class_eval do
      before :save, :save_file
      before :destroy, :delete_file
    end
  end
  
  def file_path
    File.join(File.dirname(__FILE__), *%W[.. public images #{self.filename ||= attributes[:filename]}.png])
  end
    
  def save_file
    return unless @data
    Thread.new do
      image = Magick::Image.from_blob(@data.read).first
      image.change_geometry!("80x170") { |cols, rows| image.thumbnail! cols, rows }
      image.write(file_path)
    end
  end
  
  def delete_file
    Thread.new { FileUtils.rm_rf file_path }
  end
end