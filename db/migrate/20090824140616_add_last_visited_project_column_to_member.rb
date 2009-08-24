class AddLastVisitedProjectColumnToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :last_project_id, :integer
  end

  def self.down
    remove_column :members, :last_project_id
  end
end
