class AddColorColumnToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :color, :string
  end

  def self.down
    remove_column :tasks, :color
  end
end
