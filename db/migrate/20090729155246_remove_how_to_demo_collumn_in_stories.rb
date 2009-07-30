class RemoveHowToDemoCollumnInStories < ActiveRecord::Migration
  def self.up
	remove_column :stories, :how_to_demo
  end

  def self.down
	add_column :stories, :how_to_demo, :text
  end
end
