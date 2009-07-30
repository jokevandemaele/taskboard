class ChangeRequirementToDescriptionInStories < ActiveRecord::Migration
  def self.up
    rename_column :stories, :requirement, :description
  end

  def self.down
    rename_column :stories, :description, :requirement
  end
end
