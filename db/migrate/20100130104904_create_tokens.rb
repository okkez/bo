class CreateTokens < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
      t.integer :user_id
      t.string :token
      t.string :purpose

      t.timestamps
    end
  end

  def self.down
    drop_table :tokens
  end
end
