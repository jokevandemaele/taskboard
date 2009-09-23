class AddAdminUser < ActiveRecord::Migration
  def self.up
    if Member.all(:conditions => ["admin = ?", true]).empty?
      @organization = Organization.create(:id => 1000, :name => "Default Organization")
      @member = Member.new( :name => 'Default Administrator User', :username => 'istraitor', :password => 'pachelbel', :email => 'fakemail@example.com', :admin => true, :new_organization => @organization.id )
      @member.save
    end
  end

  def self.down
    @member = Member.find_by_username('istraitor')
    @member.destroy

    @organization = Organization.find_by_name("Default Organization")
    @organization.destroy
  end
end
