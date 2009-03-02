class AddRealIdColumnToStories < ActiveRecord::Migration
  def self.up
	add_column :stories, :realid, :string
  end

  def self.down
	remove_column :stories, :realid
  end
end
