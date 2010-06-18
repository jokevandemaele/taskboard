class FixColorInUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.remove :color
      t.string :color
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :color
      t.integer :color
    end
  end
end
