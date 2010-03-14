Application.Helpers.Organizations = {
  initialize: function(){
    this._setupListeners();
  },
  
  newForm: function(){
    // Request form
    new Ajax.Request('/organizations/new', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterCreate: function(response){
    var organization = response.evalJSON().organization
    
    new Ajax.Request('/organizations/' + organization.id, {
      method: 'get',
        
      onSuccess: function(transport) {
        var container = new Element('div').update(transport.responseText);
        var organization = container.down('.organization')
        $('organizations').insert({bottom: organization});
        Effect.ScrollTo(organization, { duration: 0.2, afterFinish: organization.pulsate({ pulses: 2, duration: 0.8 }) })
      }
    });
    
    ModalDialog.close();
  },

  editForm: function(organization){
    organizationId = organization.readAttribute('data-organization-id');
    new Ajax.Request('/organizations/'+organizationId+'/edit', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },

  afterUpdate: function(response){
    ModalDialog.close();
    var organization = response.evalJSON().organization
    var h2 = $('organization-' + organization.id).down('h2')
    h2.innerHTML = organization.name;
    h2.highlight();
  },

  deleteOrganization: function(organization){
    organizationId = organization.readAttribute('data-organization-id');
    new Ajax.Request('/organizations/' + organizationId, {
      method: 'delete',
        
      onSuccess: function(transport) {
        organization.setStyle({'z-index' : 200});
        Effect.Puff(organization);
      }
    });
  },
  
  _setupListeners: function(){
    // New Organization Listener
    this._adminSideBarListener();
    // Organization List Listeners
    this._organizationListListener();
  },
  
  
  // Handles the creation of the observers for the admin sidebar (creation of organizations and send invitation)
  _adminSideBarListener: function(){
    $("admin-sidebar").observe('click', function(event){
      var target = event.element();
      if(target.match('.new_organization')){
        Organizations.newForm();
      }
    })
  },
  
  // Handles the creation of the observers for edit and remove 
  _organizationListListener: function(){
    $("organizations").observe('click', function(event){
      var target = event.element();

      // Listener for remove organization link
      if(target.match('.remove_organization')){
        organization = target.up('.organization');
        ModalDialog.yes_no("Are you sure?", function() { Organizations.deleteOrganization(organization) })
      }

      // Listener for edit organization link
      if(target.match('.edit_organization')){
        organization = target.up('.organization');
        Organizations.editForm(organization);
      }
      
    });
  }
};

// Provide a pretty shortcut
Organizations = Application.Helpers.Organizations;
