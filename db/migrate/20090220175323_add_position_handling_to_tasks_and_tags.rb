class AddPositionHandlingToTasksAndTags < ActiveRecord::Migration
  def self.up
    add_column :tasks, :relative_position_x, :integer
    add_column :tasks, :relative_position_y, :integer
    add_column :nametags, :relative_position_x, :integer
    add_column :nametags, :relative_position_y, :integer
    add_column :statustags, :relative_position_x, :integer
    add_column :statustags, :relative_position_y, :integer
  end

  def self.down
    remove_column :tasks, :relative_position_x
    remove_column :tasks, :relative_position_y
    remove_column :nametags, :relative_position_x
    remove_column :nametags, :relative_position_y
    remove_column :statustags, :relative_position_x
    remove_column :statustags, :relative_position_y
  end
end
