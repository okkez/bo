class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id
      t.date :spent_on, :null => false
      t.string :title
      t.text :note

      t.timestamps
      t.integer :lock_version, :null => false, :default => 0
    end
    add_index :events, :user_id
  end

  def self.down
    remove_index :events, :user_id
    drop_table :events
  end
end
