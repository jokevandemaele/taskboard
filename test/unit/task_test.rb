require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # self.use_instantiated_fixtures = true
  # fixtures :stories, :tasks
  # 
  # # named_scope's
  # test "named scope - not_started" do
  #   assert Task.not_started.size == 2
  # end
  # 
  # test "named scope - in_progress" do
  #   assert Task.in_progress.size == 2
  # end
  # 
  # test "named scope - finished" do
  #   assert Task.finished.empty?
  # end
  # 
  # 
  # # Remove tags => With no tags
  # test "remove tags - no tags" do
  #   t = Task.new
  #   t.story = @InProgressStory
  #   t.save
  #   t.remove_tags
  #   assert t.nametags.empty?
  #   assert t.statustags.empty?
  # end
  # 
  # # Remove tags => With nametags
  # test "remove tags - with nametags" do
  #   t = Task.new
  #   t.story = @InProgressStory
  #   # 1 Nametag
  #   n = Nametag.new
  #   n.save
  #   t.nametags << n
  #   t.save
  #   assert !t.nametags.empty?
  #   t.remove_tags
  #   assert t.nametags.empty?
  #   # 2 Nametags
  #   n1 = Nametag.new
  #   n1.save
  #   n2 = Nametag.new
  #   n2.save
  #   t.nametags << n1 << n2
  #   t.save
  #   assert !t.nametags.empty?
  #   t.remove_tags
  #   assert t.nametags.empty?
  # end
  # # Remove tags => With a statustag
  # test "remove tags - with statustags" do
  #   t = Task.new
  #   t.story = @InProgressStory
  #   # 1 Statustag
  #   s = Statustag.new
  #   s.save
  #   t.statustags << s
  #   t.save
  #   assert !t.statustags.empty?
  #   t.remove_tags
  #   assert t.statustags.empty?
  #   # 2 Statustag
  #   s1 = Statustag.new
  #   s1.save
  #   s2 = Statustag.new
  #   s2.save
  #   t.statustags << s1 << s2
  #   t.save
  #   assert !t.statustags.empty?
  #   t.remove_tags
  #   assert t.statustags.empty?
  # end
  # 
  # # Remove tags => With a nametag and a statustag  
  # test "remove tags - with nametags and statutags" do
  #   t = Task.new
  #   t.story = @InProgressStory
  #   # 1 Statustag, 1 Nametag
  #   s = Statustag.new
  #   s.save
  #   n = Nametag.new
  #   n.save
  #   t.statustags << s 
  #   t.nametags << n
  #   t.save
  #   assert !t.statustags.empty?
  #   assert !t.nametags.empty?
  #   t.remove_tags
  #   assert t.statustags.empty?
  #   assert t.nametags.empty?
  #   # 2 Statustags, 2 Nametags
  #   s1 = Statustag.new
  #   s1.save
  #   s2 = Statustag.new
  #   s2.save
  #   n1 = Nametag.new
  #   n1.save
  #   n2 = Nametag.new
  #   n2.save
  #   t.nametags << n1 << n2
  #   t.statustags << s1 << s2 
  #   t.save
  #   assert !t.statustags.empty?
  #   assert !t.nametags.empty?
  #   t.remove_tags
  #   assert t.statustags.empty?
  #   assert t.nametags.empty?
  # end
  # 
end
