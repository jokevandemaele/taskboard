Factory.define :task do |t|
  t.sequence(:name) {|n| "Task #{n}" }
  t.association(:story)
end