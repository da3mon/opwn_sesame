require "RMagick"

class Image
  include DataMapper::Resource
  include FileAttachment

  property :id, Serial, :key => true
  property :filename, String, :nullable => false
  property :link, String, :length => 0..255
  property :entry_system_id, Integer

  def initialize(attrs)
    @data = attrs.delete(:data) if attrs[:data]
    super
  end
end
