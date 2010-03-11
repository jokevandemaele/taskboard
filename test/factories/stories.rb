Factory.define :story do |t|
  t.sequence(:name) {|n| "Story #{n}" }
  t.description "Description"
  t.association(:project)
  t.sequence(:realid) {|n| "PR#{n}"}
end