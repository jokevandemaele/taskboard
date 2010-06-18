Factory.define :guest_team_membership do |t|
  t.association(:user)
  t.association(:organization)
end