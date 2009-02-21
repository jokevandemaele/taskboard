class AddColorColumnToTags < ActiveRecord::Migration
  def self.up
    add_column :nametags, :color, :integer
    add_column :statustags, :color, :integer
  end

  def self.down
    remove_column :nametags, :color
    remove_column :statustags, :color
  end
end
