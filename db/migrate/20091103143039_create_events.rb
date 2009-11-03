class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.date :spent_on, :null => false
      t.string :title
      t.text :note

      t.timestamps
      t.integer :lock_version, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :events
  end
end
