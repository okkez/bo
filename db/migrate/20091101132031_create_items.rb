class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :event_id
      t.integer :founds_in
      t.integer :founds_out
      t.timestamps
      t.integer :lock_version, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :items
  end
end
