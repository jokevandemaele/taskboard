Factory.define :team do |t|
  t.sequence(:name) {|n| "Team #{n}" }
  t.color   "0000FF"
  t.association(:organization)
end