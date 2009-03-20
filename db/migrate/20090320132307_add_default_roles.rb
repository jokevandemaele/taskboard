class AddDefaultRoles < ActiveRecord::Migration
  def self.up
    tm = Role.new :name => "Team Member"
    tm.save
    po = Role.new :name => "Product Owner"    
    po.save
    sm = Role.new :name => "Scrum Master"
    sm.save
  end

  def self.down
    tm = Role.all(:conditions => "name = \"Team Member\"")
    tm.destroy

    po = Role.all(:conditions => "name = \"Product Owner\"")
    po.destroy

    sm = Role.all(:conditions => "name = \"Scrum Master\"")
    sm.destroy
  end
end
