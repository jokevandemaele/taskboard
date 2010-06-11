Application.Helpers.Stories = {
  initialize: function(){
    this._setupListeners();
  },
  
  newForm: function(projectId){
    // Request form
    new Ajax.Request('/projects/'+ projectId + '/stories/new', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterCreate: function(response){
    location = location;
  },
  
  editForm: function(storyId, projectId){
    new Ajax.Request('/projects/'+projectId+'/stories/'+storyId+'/edit', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterUpdate: function(response){
    location = location;
  },
  
  // deleteTeam: function(team, organization){
  //   organizationId = organization.readAttribute('data-organization-id');
  //   teamId = team.readAttribute('data-team-id');
  //   new Ajax.Request('/organizations/' + organizationId + '/teams/' + teamId, {
  //     method: 'delete',
  //       
  //     onSuccess: function(transport) {
  //       team.setStyle({'z-index' : 200});
  //       Effect.Fade(team);
  //     }
  //   });
  // },
  // 
  // hideAllStories: function(){
  //   $$('.team_info').each(function(teamInfo){
  //     teamInfo.hide();
  //   });
  // },
  // 
  // displayTeamInfo: function(team, organization){
  //   this.hideAllStories();
  //   teamId = team.readAttribute('data-team-id');
  //   teamInfoDiv = $('team-info-' + teamId);
  //   if(!teamInfoDiv){
  //     organizationId = organization.readAttribute('data-organization-id');
  //     new Ajax.Request('/organizations/'+organizationId+'/teams/'+teamId+'/team_info', {
  //       method: 'get',
  //     
  //       onSuccess: function(transport) {
  //         teamInfoDiv = new Element('div', { id : 'team-info-'+teamId, 'class' : 'team_info admin_container'}).update(transport.responseText);
  //         $('admin-content').insert({top: teamInfoDiv});
  //         Stories.displayTeamInfo(team,organization)
  //       }
  //     });
  //   }else{
  //     var top = organization.cumulativeOffset().top - $('admin-content').cumulativeOffset().top + 10
  //     teamInfoDiv.setStyle({ position: 'absolute', top: top + 'px', left: '-' + (teamInfoDiv.getWidth() + 10) + 'px'});
  //     teamInfoDiv.show();
  //   }
  // },
  // 
  // hideTeamInfo: function(team){
  //   $('team-info-' + teamId).hide();
  // },
  // 
  // addUser: function(user){
  //   user.fade()
  //   var organizationId = user.readAttribute('data-organization-id');
  //   var teamId = user.readAttribute('data-team-id');
  //   var userId = user.readAttribute('data-user-id');
  //   var userName = user.readAttribute('data-user-name');
  //   var userAvatar = user.readAttribute('data-user-avatar');
  //   var userNametag = user.readAttribute('data-user-nametag');
  //   var userContainer = new Element('div', { 'class' : 'user', 'data-user-name' : userName, 'data-user-avatar' : userAvatar, 'data-user-nametag' : userNametag, 'data-organization-id' : organizationId, 'data-team-id' : teamId, 'data-user-id' : userId})
  //   // Add the picture
  //   var avatar = new Element('img', { src : userAvatar});
  //   var avatarContainer = new Element('div', {'class' : 'avatar'});
  //   avatarContainer.insert({bottom: avatar})
  //   userContainer.insert({bottom: avatarContainer});
  //   
  //   // Add the nametag
  //   var nametagContainer = new Element('div', {'class' : 'name'}).update(userNametag);
  //   userContainer.insert({bottom: nametagContainer});
  // 
  //   // Add Remove Button
  //   userContainer.insert({bottom: new Element('div', {'class': 'remove', 'title' : 'Remove From Team'})})
  //   
  //   userContainer.hide();
  //   $('team_users').insert({bottom: userContainer});
  //   userContainer.appear();
  //   new Ajax.Request('/organizations/'+organizationId+'/teams/'+teamId+'/users/'+userId, {method: 'post'});
  // },
  // 
  // removeUser: function(user){
  //   user.fade()
  //   var organizationId = user.readAttribute('data-organization-id');
  //   var teamId = user.readAttribute('data-team-id');
  //   var userId = user.readAttribute('data-user-id');
  //   var userName = user.readAttribute('data-user-name');
  //   var userAvatar = user.readAttribute('data-user-avatar');
  //   var userNametag = user.readAttribute('data-user-nametag');
  //   var userContainer = new Element('div', { 'class' : 'user', 'data-user-name' : userName, 'data-user-avatar' : userAvatar, 'data-user-nametag' : userNametag, 'data-organization-id' : organizationId, 'data-team-id' : teamId, 'data-user-id' : userId})
  // 
  //   // Add the name
  //   var nameContainer = new Element('div', {'class' : 'name'}).update(userName);
  //   userContainer.insert({bottom: nameContainer});
  // 
  //   // Add Add Button
  //   userContainer.insert({bottom: new Element('div', {'class': 'add'}).update('add to team')})
  //   
  //   userContainer.hide();
  //   $('organization_users').insert({bottom: userContainer});
  //   userContainer.appear();
  //   
  //   new Ajax.Request('/organizations/'+organizationId+'/teams/'+teamId+'/users/'+userId, {method: 'delete'});
  // },
  // 
  _setupListeners: function(){
    // Organization List Listeners
    this._menuListeners();
  },
  
  // Handles the creation of the observers for the menu
  _menuListeners: function(){
    if($('menu')){
      $('menu').observe('click', function(event){
        var target = event.element();
  
        // Listener for add story
        if(target.match('.new_story')){
          projectId = target.readAttribute('data-project-id');
          Stories.newForm(projectId);
        }
        // // Listener for remove story
        // if(target.match('.remove_story')){
        //   story = target.up('.story');
        //   projectId = target.readAttribute('data-project-id');
        //   ModalDialog.yes_no("Are you sure?", function() { Stories.deleteTeam(team, organization) })
        // }
        //   
        // // Listener for edit story
        // if(target.match('.edit_team')){
        //   organization = target.up('.organization');
        //   team = target.up('.team');
        //   Stories.editForm(team, organization);
        // }
  
      });
      
      
    
    }
  }
};

// Provide a pretty shortcut
Stories = Application.Helpers.Stories;
