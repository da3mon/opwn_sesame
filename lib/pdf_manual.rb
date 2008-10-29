class PdfManual
  include DataMapper::Resource
  include FileAttachment

  property :id, Serial, :key => true
  property :filename, String
  property :link, Text
  property :entry_system_id, Integer
  
  belongs_to :entry_system

  def initialize(attrs={})
    self.data = attrs.delete(:data) if attrs[:data]
    super
  end
  
  def extension
    'pdf'
  end
  
  protected
  def directory
    'pdfs'
  end
  
  def save_file_type
    File.open(file_path, 'w') {|f| f.write data.read}
  end
end
