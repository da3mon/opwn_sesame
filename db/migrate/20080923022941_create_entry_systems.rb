class CreateEntrySystems < ActiveRecord::Migration
  def self.up
    create_table :entry_systems do |t|
      t.string :name
      t.string :manufacturer
      t.string :prompt
      t.integer :password
      t.timestamps
    end
  end

  def self.down
    drop_table :entry_systems
  end
end
