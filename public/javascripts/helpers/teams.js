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
  // 
  _setupListeners: function(){
    // Organization List Listeners
    this._organizationListListener();
  },
  
  // Handles the creation of the observers for edit and remove 
  _organizationListListener: function(){
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
  }
};

// Provide a pretty shortcut
Teams = Application.Helpers.Teams;
