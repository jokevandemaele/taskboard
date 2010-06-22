Application.Helpers.Users = {
  initialize: function(){
    this._setupListeners();
  },
  
  newForm: function(organizationId){
    // Request form
    new Ajax.Request('/organizations/'+ organizationId + '/users/new', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterCreate: function(response){
    var user = response.evalJSON();
    new Ajax.Request('/organizations/' + user.organization + '/users/' + user.id, {
      method: 'get',
        
      onSuccess: function(transport) {
        var container = new Element('div').update(transport.responseText);
        var user_container = container.down('.user')
        
        $('organization-'+ user.organization).down('.list.users').insert({bottom: user_container});
        user_container.highlight({ duration: 0.8 });
      }
    });
    ModalDialog.close();
  },
  
  editForm: function(user, organization){
    organizationId = organization.readAttribute('data-organization-id');
    userId = user.readAttribute('data-user-id');
    new Ajax.Request('/organizations/'+organizationId+'/users/'+userId+'/edit', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterUpdate: function(response){
    ModalDialog.close();
    var user = response
    var user_container = $('user-' + user.id)
    var name = user_container.down('.name')
    
	if(user.is_current){
		// update picture and name from top
		$('current_user_name').innerHTML = user.name;
		$('current_user_picture').src = user.avatar;
	}
	
	name.innerHTML = user.name;
    user_container.highlight({ duration: 0.8 });
  },
  
  deleteUser: function(user, organization){
    organizationId = organization.readAttribute('data-organization-id');
    userId = user.readAttribute('data-user-id');
    Effect.Fade(user);
    new Ajax.Request('/organizations/' + organizationId + '/users/' + userId, { method: 'delete'});
  },

  toggleAdmin: function(user, organization){
    organizationId = organization.readAttribute('data-organization-id');
    userId = user.readAttribute('data-user-id');
    toggleAdminContainer = user.down('.toggle_admin')
    if(toggleAdminContainer.hasClassName('is_org_admin')){
      toggleAdminContainer.removeClassName('is_org_admin');
      toggleAdminContainer.addClassName('is_user');
    }else{
      toggleAdminContainer.removeClassName('is_user');
      toggleAdminContainer.addClassName('is_org_admin');
    }
    new Ajax.Request('/organizations/'+organizationId+'/users/'+userId+'/toggle_admin', { method: 'post' });
  },

  _setupListeners: function(){
    // Organization List Listeners
    this._organizationListListener();
  },
  
  // Handles the creation of the observers for edit and remove 
  _organizationListListener: function(){
    $("organizations").observe('click', function(event){
      var target = event.element();

      // Listener for add
      if(target.match('.new_user')){
        organizationId = target.up('.organization').readAttribute('data-organization-id');
        Users.newForm(organizationId);
      }

      // Listener for remove
      if(target.match('.remove_user')){
        organization = target.up('.organization');
        user = target.up('.user');
        ModalDialog.yes_no("Are you sure?", function() { Users.deleteUser(user, organization) })
      }
      
      // Listener for edit
      if(target.match('.edit_user')){
        organization = target.up('.organization');
        user = target.up('.user');
        Users.editForm(user, organization);
      }

      // Listener for toggle_admin
      if(target.match('.toggle_admin')){
        organization = target.up('.organization');
        user = target.up('.user');
        Users.toggleAdmin(user, organization);
      }
      
    });
  }
};

// Provide a pretty shortcut
Users = Application.Helpers.Users;
