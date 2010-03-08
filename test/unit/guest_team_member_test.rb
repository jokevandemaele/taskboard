require File.dirname(__FILE__) + '/../test_helper'

class GuestTeamMembershipTest < ActiveSupport::TestCase
  context "GuestTeamMembership" do
    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    # This is commented because we wan't a different error message, see 'When creating a GuestTeamMembership' context
    # should_validate_presence_of :user, :project
    
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_belong_to :team
    should_belong_to :project
    should_belong_to :user
  end

  context "When creating a GuestTeamMembership" do
    setup do
      @dfaraday = Factory(:dfaraday)
      @project = Factory(:do_weird_experiments)
      @team_membership = GuestTeamMembership.new(:user => @dfaraday, :project => @project)
    end

    should "be saved if all the data is present" do
      assert @team_membership.save
    end

    # context "if user is not present" do
    #   setup do
    #     @team_membership = GuestTeamMembership.new(:project => @project)
    #   end
    # 
    #   should "return an error" do
    #     assert !@team_membership.save
    #   end
    # end
    # 
    # context "if project is not present" do
    #   setup do
    #     @team_membership = GuestTeamMembership.new(:user => @dfaraday)
    #   end
    # 
    #   should "return an error" do
    #     assert !@team_membership.save
    #   end
    # end
    
  end
  
  # test "create membership and all fields must be filled but teams" do
  #   team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments))
  #   assert team_membership.save
  # 
  #   team_membership1 = GuestTeamMembership.new(:project => projects(:do_weird_experiments))
  #   assert !team_membership1.save
  # 
  #   team_membership2 = GuestTeamMembership.new(:member => members(:dfaraday))
  #   assert !team_membership2.save
  # end
  # 
  # test "do not allow to save a guest member if it is already on the project" do 
  #   team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments))
  #   assert team_membership.save
  #   team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:do_weird_experiments))
  #   assert !team_membership.save
  # end
  # 
  # test "do not allow to save a guest member if it already belongs to the organization" do 
  #   team_membership = GuestTeamMembership.new(:member => members(:dfaraday), :project => projects(:find_the_island))
  #   assert !team_membership.save
  # end
  # 
  # test "hash to array without index" do
  #   hash = HashWithIndifferentAccess.new("0" => 0, "1" => 1, "2" => 2)
  #   array = hash.to_a_with_no_index
  #   assert_equal [0,1,2], array
  # end
  # 
  # test "remove guest member from organization works and deletes nametags" do
  #   team_membership = GuestTeamMembership.create(:member => members(:kausten), :project => projects(:fake_planecrash))
  #   team_membership = GuestTeamMembership.create(:member => members(:kausten), :project => projects(:find_the_island))
  #   assert projects(:fake_planecrash).guest_members.include?(members(:kausten))
  #   assert projects(:find_the_island).guest_members.include?(members(:kausten))
  #   nametag = Nametag.new(:task_id => tasks(:in_progress_1).id, :member_id => members(:kausten).id, :relative_position_x => 1, :relative_position_y => 1)
  #   task = tasks(:in_progress_1)
  #   assert nametag.save
  #   assert task.nametags.include?(nametag)
  #   GuestTeamMembership.remove_from_organization(members(:kausten), organizations(:widmore_corporation))
  #   assert !projects(:fake_planecrash).guest_members.include?(members(:kausten))
  #   assert !projects(:find_the_island).guest_members.include?(members(:kausten))
  #   assert !task.nametags.include?(nametag)
  # end
end
