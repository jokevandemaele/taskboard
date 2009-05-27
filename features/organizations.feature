Feature: Organizations
  In order to administer organizations
  As an admin
  I want to create, delete, edit, organizations
  
  Scenario: Organization List as a simple user
    Given I am logged in as dfaraday with password test
	And I have organizations named Widmore Corporation
    When I go to the list of organizations
    Then I should see "Widmore Corporation"

  Scenario: Organization List as system admin
    Given I am logged in as clittleton with password test
	And I have organizations named Widmore Corporation
    When I go to the list of organizations
    Then I should see all the organizations

  Scenario: Organization List as organization admin
    Given I am logged in as jburke with password test
    When I go to the list of organizations
    Then I should see "Dharma Initiative"

  # Simple User's view
  Scenario: Simple Users should see only their organizations
    Given I am logged in as jburke with password test
    When I go to the list of organizations
    Then I should not see "Widmore Corporation"

	#   Scenario: Create Organization as admin
	#     Given I am logged in as clittleton with password test
	#     When I go to the list of organizations
	# And I follow "new organization"
	# And I fill in "organization[name]" with "Oceanic Six"
	#     Then I should see "Oceanic Six"

  Scenario: Simple Users should not be able to destroy organizations
	Given I am logged in as dfaraday with password test
	When I go to destroy organization 1
	Then I should see "Access Denied"

  Scenario: An organization's admin should be able to destroy it
	Given I am logged in as jburke with password test
	When I go to destroy organization 2
	Then I should see "successfully destroyed organization"

  Scenario: An organization's admin should be able to see it
    Given I am logged in as jburke with password test
    When I view organization 2
    Then I should see "Dharma Initiative"

