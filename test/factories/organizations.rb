Factory.define :organization do |t|
  t.sequence(:name) {|n| "Organization #{n}" }
end