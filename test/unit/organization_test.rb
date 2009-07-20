require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  fixtures :organizations
  
  test "members_ordered_by_role works as expected" do
    organization = organizations(:widmore_corporation)
    
    admins = []
    org_admins = []
    normal = []
    organization.members.each do |member|
      normal << member if !member.admin? && !member.admins?(organization)
      org_admins << member if !member.admin? && member.admins?(organization)
      admins << member if member.admin?
    end
    expected_result = admins + org_admins + normal
    assert_equal expected_result, organization.members_ordered_by_role
  end
end
