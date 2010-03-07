Factory.define :dharma_team, :class => Team do |t|
  t.name   "Dharma Team"
  t.color   "0000FF"
  t.organization { begin Organization.find_by_name('Dharma Initiative') rescue Factory(:dharma_initiative) end }
end