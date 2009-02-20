class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.integer :story_id
      t.text :description
      t.string :status, :default => 'undefined'

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
