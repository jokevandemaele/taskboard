class ChangeSomeAttributeNames < ActiveRecord::Migration
  def self.up
    rename_column :stories, :importance, :priority
    rename_column :stories, :estimate, :size
    rename_column :stories, :notes, :requirement
     change_column_default :tasks, :status, 'not_started'
  end

  def self.down
    rename_column :stories, :priority, :importance
    rename_column :stories, :size, :estimate
    rename_column :stories, :requirement, :notes
    change_column_default :tasks, :status, 'undefined'
  end
end
