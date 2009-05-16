Given /^I have organizations named (.+)$/ do |names|
  names.split(', ').each do |name|
    @organization = Organization.find_by_name(name)
  end
  @organization.should_not be_nil
end

Then /^I should see all the organizations$/ do
  @organizations = Organization.find(:all)
  @organizations.should_not be_nil
  @organizations.each {|organization| response.should contain(organization.name)} 
end

When /^I create the organization "([^\"]*)"$/ do |arg1|
  
end

