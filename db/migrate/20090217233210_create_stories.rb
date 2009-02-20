class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.string :name
      t.integer :project_id
      t.integer :importance
      t.integer :estimate
      t.text :how_to_demo
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
