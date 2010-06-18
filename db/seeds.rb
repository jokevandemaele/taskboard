default_organization = Organization.create(:id => 1000, :name => "Default Organization")

default_user_data = { 
  :name => 'Default Administrator User', 
  :login => 'admin', 
  :password => 'secret',
  :password_confirmation => 'secret', 
  :email => 'fakemail@example.com', 
  :new_organization => default_organization 
}

default_user = User.create(default_user_data)
default_user.toggle_admin!
