class AddOldPriorityToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :old_priority, :integer
  end

  def self.down
    remove_column :stories, :old_priority
  end
end
