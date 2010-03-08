require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < ActiveSupport::TestCase
  context "Team" do
    setup do
      Factory(:team)
    end
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_have_and_belong_to_many :users
    should_have_and_belong_to_many :projects
    should_belong_to :organization

    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    should_validate_uniqueness_of :name
  end
end
