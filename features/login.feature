Feature: Login
  In order login to the site
  As a guest user
  I want log in

  Scenario: I try to access without logging in
	Given I am not logged in
	When I go to the taskboard number 1
	Then I should be on the login screen

  Scenario: I try to access without logging in, i login, then i'm redirected to where i tried to access
	Given I am not logged in
	And The user dfaraday exists
	When I go to the taskboard number 1
	And I log in as dfaraday with password test
	Then I should be on the taskboard number 1
	
  Scenario: Login as a simple user
	Given I am not logged in
	And The user dfaraday exists
	When I log in as dfaraday with password test
	Then I should be logged as dfaraday
    
  Scenario: Login a an admin
	Given I am not logged in
	And The user clittleton exists
	When I log in as clittleton with password test
	Then I should be logged as clittleton
	And I should be admin
	
    