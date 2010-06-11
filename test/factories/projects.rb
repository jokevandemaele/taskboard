Factory.define :project do |t|
  t.sequence(:name) {|n| "Project #{n}" }
  t.association(:organization)
end