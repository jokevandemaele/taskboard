class CreateStatustags < ActiveRecord::Migration
  def self.up
    create_table :statustags do |t|
      t.string :status
      t.integer :task_id

      t.timestamps
    end
  end

  def self.down
    drop_table :statustags
  end
end
