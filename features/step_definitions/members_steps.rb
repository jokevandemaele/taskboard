Given /^I am logged in as (.+) with password (.+)$/ do |username,password|
    visit "/login"
    fill_in("member_username", :with => username)
    fill_in("member_password", :with => password)
    click_button("login-button")
    Member.find(session[:member]).should_not be_nil
end

Given /^I am not logged in$/ do
  defined?(session[:member]).should_not be_true
end

Given /^The user (.*) exists$/ do |user|
  Member.find_by_username(user).should_not be_nil
end

When /^I log in as (.+) with password (.+)$/ do |username,password|
  visit "/login"
  fill_in("member_username", :with => username)
  fill_in("member_password", :with => password)
  click_button("login-button")
end

Then /^I should be logged as (.+)$/ do |username|
  defined?(session[:member]).should_not be_false
  @member = Member.find(session[:member])
  @member.username.should contain(username)
end

Then /^I should be admin$/ do
  @member = Member.find(session[:member])
  @member.admin?.should be_true
end

When /^I view organization ([0-9]+)$/ do |organization|
  visit "/admin/organizations/show/#{organization}"
end

