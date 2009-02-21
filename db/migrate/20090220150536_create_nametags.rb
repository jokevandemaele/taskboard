class CreateNametags < ActiveRecord::Migration
  def self.up
    create_table :nametags do |t|
      t.string :name
      t.integer :task_id

      t.timestamps
    end
  end

  def self.down
    drop_table :nametags
  end
end
