Application.Helpers.Teams = {
  initialize: function(){
    this._setupListeners();
  },
  
  newForm: function(organizationId){
    // Request form
    new Ajax.Request('/organizations/'+ organizationId + '/teams/new', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterCreate: function(response){
    var team = response.evalJSON().team
    new Ajax.Request('/organizations/' + team.organization_id + '/teams/' + team.id, {
      method: 'get',
        
      onSuccess: function(transport) {
        var container = new Element('div').update(transport.responseText);
        var team_container = container.down('.team')
        
        $('organization-'+ team.organization_id).down('.list.teams').insert({bottom: team_container});
        team_container.highlight({ duration: 0.8 });
      }
    });
    ModalDialog.close();
  },
  
  editForm: function(team, organization){
    organizationId = organization.readAttribute('data-organization-id');
    teamId = team.readAttribute('data-team-id');
    new Ajax.Request('/organizations/'+organizationId+'/teams/'+teamId+'/edit', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterUpdate: function(response){
    ModalDialog.close();
    var team = response.evalJSON().team
    var team_container = $('team-' + team.id)
    var name = team_container.down('.name')
    name.innerHTML = team.name;
    team_container.highlight({ duration: 0.8 });
  },
  
  deleteTeam: function(team, organization){
    organizationId = organization.readAttribute('data-organization-id');
    teamId = team.readAttribute('data-team-id');
    new Ajax.Request('/organizations/' + organizationId + '/teams/' + teamId, {
      method: 'delete',
        
      onSuccess: function(transport) {
        team.setStyle({'z-index' : 200});
        Effect.Fade(team);
      }
    });
  },
  
  hideAllTeams: function(){
    $$('.team_info').each(function(teamInfo){
      teamInfo.hide();
    });
  },
  
  displayTeamInfo: function(team, organization){
    this.hideAllTeams();
    teamId = team.readAttribute('data-team-id');
    teamInfoDiv = $('team-info-' + teamId);
    if(!teamInfoDiv){
      organizationId = organization.readAttribute('data-organization-id');
      new Ajax.Request('/organizations/'+organizationId+'/teams/'+teamId+'/team_info', {
        method: 'get',
      
        onSuccess: function(transport) {
          teamInfoDiv = new Element('div', { id : 'team-info-'+teamId, 'class' : 'team_info admin_container'}).update(transport.responseText);
          $('admin-content').insert({top: teamInfoDiv});
          Teams.displayTeamInfo(team,organization)
        }
      });
    }else{
      var top = organization.cumulativeOffset().top - $('admin-content').cumulativeOffset().top + 10
      teamInfoDiv.setStyle({ position: 'absolute', top: top + 'px', left: '-' + (teamInfoDiv.getWidth() + 10) + 'px'});
      teamInfoDiv.show();
    }
  },

  hideTeamInfo: function(team){
    if($('team-info-' + teamId)){
      $('team-info-' + teamId).hide();
    }
  },
  
  addUser: function(user){
    user.fade({duration: 0.2});
    var organizationId = user.readAttribute('data-organization-id');
    var teamId = user.readAttribute('data-team-id');
    var userId = user.readAttribute('data-user-id');
    var userName = user.readAttribute('data-user-name');
    var userAvatar = user.readAttribute('data-user-avatar');
    var userNametag = user.readAttribute('data-user-nametag');
    var userContainer = new Element('div', { 'class' : 'user', 'data-user-name' : userName, 'data-user-avatar' : userAvatar, 'data-user-nametag' : userNametag, 'data-organization-id' : organizationId, 'data-team-id' : teamId, 'data-user-id' : userId})
    // Add the picture
    var avatar = new Element('img', { src : userAvatar});
    var avatarContainer = new Element('div', {'class' : 'avatar'});
    avatarContainer.insert({bottom: avatar})
    userContainer.insert({bottom: avatarContainer});
    
    // Add the nametag
    var nametagContainer = new Element('div', {'class' : 'name'}).update(userNametag);
    userContainer.insert({bottom: nametagContainer});

    // Add Remove Button
    userContainer.insert({bottom: new Element('div', {'class': 'remove', 'title' : 'Remove From Team'})})
    
    userContainer.hide();
    $('team_users').insert({bottom: userContainer});
    userContainer.appear();
    new Ajax.Request('/organizations/'+organizationId+'/teams/'+teamId+'/users/'+userId, {method: 'post'});
  },
  
  removeUser: function(user){
    user.fade({duration: 0.2});
    var organizationId = user.readAttribute('data-organization-id');
    var teamId = user.readAttribute('data-team-id');
    var userId = user.readAttribute('data-user-id');
    var userName = user.readAttribute('data-user-name');
    var userAvatar = user.readAttribute('data-user-avatar');
    var userNametag = user.readAttribute('data-user-nametag');
    var userContainer = new Element('div', { 'class' : 'user', 'data-user-name' : userName, 'data-user-avatar' : userAvatar, 'data-user-nametag' : userNametag, 'data-organization-id' : organizationId, 'data-team-id' : teamId, 'data-user-id' : userId})

    // Add the name
    var nameContainer = new Element('div', {'class' : 'name'}).update(userName);
    userContainer.insert({bottom: nameContainer});

    // Add Add Button
    userContainer.insert({bottom: new Element('div', {'class': 'add'}).update('add to team')})
    
    userContainer.hide();
    $('organization_users').insert({bottom: userContainer});
    userContainer.appear();
    
    new Ajax.Request('/organizations/'+organizationId+'/teams/'+teamId+'/users/'+userId, {method: 'delete'});
  },
  
  _setupListeners: function(){
    // Organization List Listeners
    this._organizationListListener();
    this._editTeamUsersListeners();
  },
  
  // Handles the creation of the observers for edit and remove 
  _organizationListListener: function(){
    // Observe clicks on edit and remove buttons for teams
    if($('organizations')){
      $("organizations").observe('click', function(event){
        var target = event.element();

        // Listener for add team
        if(target.match('.new_team')){
          organizationId = target.up('.organization').readAttribute('data-organization-id');
          Teams.newForm(organizationId);
        }

        // Listener for remove team
        if(target.match('.remove_team')){
          organization = target.up('.organization');
          team = target.up('.team');
          ModalDialog.yes_no("Are you sure?", function() { Teams.deleteTeam(team, organization) })
        }

        // Listener for edit team
        if(target.match('.edit_team')){
          organization = target.up('.organization');
          team = target.up('.team');
          Teams.editForm(team, organization);
        }

      });
      // Observe mouse over on team
      $("organizations").observe('mouseover', function(event){
        var target = event.element();
        organization = target.up('.organization');
        if(target.match('.team')){
          Teams.displayTeamInfo(target,organization)
        }else{
          if(!target.up('.team')){
            Teams.hideAllTeams();
          }
        }
      });

      // Observe mouse out on team
      $("organizations").observe('mouseout', function(event){
        var target = event.element();
        if(target.match('.team') && !(event.toElement.parentNode == target)){
          organization = target.up('.organization');
          Teams.hideTeamInfo(target)
        }
      });
    }
  },
  
  _editTeamUsersListeners: function(){
    if($("edit_users")){
      $("edit_users").observe('click', function(event){
        var target = event.element();
        // Add user to team
        if(target.match('.add')){
          Teams.addUser(target.up('.user'));
        }
        if(target.match('.remove')){
          Teams.removeUser(target.up('.user'));
        }
      });
    }
  }
};

// Provide a pretty shortcut
Teams = Application.Helpers.Teams;
