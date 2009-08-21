class SetDefaultPriorityToZero < ActiveRecord::Migration
  def self.up
    stories = Story.find_all_by_priority(nil)
    stories.each do |story|
      story.priority = 0
      story.save
    end
  end

  def self.down
  end

end
