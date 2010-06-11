@organization = Organization.create(:id => 1000, :name => "Default Organization")
@user = User.new( :name => 'Default Administrator User', :login => 'istraitor', :password => 'pachelbel',:password_confirmation => 'pachelbel', :email => 'fakemail@example.com', :new_organization => @organization )
@user.save
@user.toggle_admin!
