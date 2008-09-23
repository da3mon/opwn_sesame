class CreatePdfManuals < ActiveRecord::Migration
  def self.up
    create_table :pdf_manuals do |t|
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.integer :size
      t.integer :width
      t.integer :height
      t.timestamps
    end
  end

  def self.down
    drop_table :pdf_manuals
  end
end
