class PdfManual
  include DataMapper::Resource
  include FileAttachment

  property :id, Serial, :key => true
  property :filename, String
  property :content_type, String
  property :link, Text
  property :entry_system_id, Integer
  
  belongs_to :entry_system

  def initialize(attrs)
    @data = attrs.delete(:data) if attrs[:data]
    super
  end
end
