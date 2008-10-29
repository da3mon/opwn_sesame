module FileAttachment
  def self.included(including_class)
    including_class.class_eval do
      before :save, :save_file
      before :destroy, :delete_file
      attr_accessor :data
    end
  end
  
  def file_path
    File.join(File.dirname(__FILE__), *%W[.. public #{self.directory} #{self.filename ||= attributes[:filename]}.#{self.extension}])
  end
    
  def save_file
    return unless data
    save_file_type
  end
  
  def delete_file
    FileUtils.rm_rf file_path
  end
end