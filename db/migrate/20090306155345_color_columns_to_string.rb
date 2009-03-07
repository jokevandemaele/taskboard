class ColorColumnsToString < ActiveRecord::Migration
  def self.up
	change_column :members, :color, :string
	change_column :teams, :color, :string
  end

  def self.down
	change_column :members, :color, :integer
	change_column :teams, :color, :integer
  end
end
