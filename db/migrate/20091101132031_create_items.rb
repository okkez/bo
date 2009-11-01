class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title
      t.text :note
      t.integer :amount, :null => false
      t.timestamps
      t.integer :lock_version, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :items
  end
end
