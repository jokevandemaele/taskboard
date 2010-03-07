require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  context "User" do
    setup do
      @user = Factory(:dfaraday)
    end
    subject { @user }

    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    should_validate_presence_of :email, :login
    should_allow_values_for :email, "contacto@basketplace.com", "test@test.com"
    should_not_allow_values_for :email, "blo", "sao@sadf", "asdasdg@sadasdg.asioghd"

    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_have_and_belong_to_many :teams
    should_have_many :organization_memberships

    # context "If i destroy a user" do
    #   # ...
    #   should "destroy all its organization memberships" do
    #   end
    # end
  end
end
