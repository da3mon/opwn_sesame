class EntrySystem < ActiveRecord::Base
  has_many :image
  has_many :pdf_manual
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_presence_of :manufacturer, :on => :create, :message => "can't be blank"
end
