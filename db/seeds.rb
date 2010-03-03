@organization = Organization.create(:id => 1000, :name => "Default Organization")
@member = Member.new( :name => 'Default Administrator User', :username => 'istraitor', :password => 'pachelbel', :email => 'fakemail@example.com', :admin => true, :new_organization => @organization.id )
@member.save