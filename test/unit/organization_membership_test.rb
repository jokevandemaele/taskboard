require 'test_helper'

class OrganizationMembershipTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "adminitered namescope works as expected" do
    assert_equal 1, members(:cwidmore).organization_memberships.administered.size
    assert_equal 0, members(:dfaraday).organization_memberships.administered.size
  end
end
