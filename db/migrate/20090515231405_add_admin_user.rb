class AddAdminUser < ActiveRecord::Migration
  def self.up
    @member = Member.new
    @member.name = 'admin'
    @member.username = 'istraitor'
    @member.password = 'pachelbel'
    @member.admin = true
    @member.save
  end

  def self.down
    @member = Member.find_by_name('admin')
    @member.destroy
  end
end
