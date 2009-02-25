class UpdateNametagsTable < ActiveRecord::Migration
  def self.up
	add_column :nametags, :member_id, :integer
	remove_column :nametags, :color
  end

  def self.down
	remove_column :nametags, :member_id
	add_column :nametags, :color, :integer
  end
end
