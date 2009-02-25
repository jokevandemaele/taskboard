class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.integer :color
      t.string :username
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
