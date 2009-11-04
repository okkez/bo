class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :event_id
      t.integer :founds_in
      t.integer :founds_out
      t.timestamps
      t.integer :lock_version, :null => false, :default => 0
    end
    add_index :items, :event_id
  end

  def self.down
    remove_index :items, :event_id
    drop_table :items
  end
end
