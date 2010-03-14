Application.Helpers.Organizations = {
  initialize: function(){
    this._setupListeners();
  },
  
  _setupListeners: function(){
    // New Organization Listener
    this._adminSideBarListener();
    // Edit Organization Listener
    // Destroy Organization Listener
    // New Project Listener
  },
  
  
  // Handles the creation of the observers for the admin sidebar (creation of organizations and send invitation)
  _adminSideBarListener: function(){
    $("admin-sidebar").observe('click', function(event){
      
      var target = event.element();
      if(target.match('.new_organization')){
        // Request form
        // new Ajax.Request('/organizations/new', {
        //   method: 'get',
        //     
        //   onSuccess: function(transport) {
        //     var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        //     ModalDialog.open(formContainer, { ignoreFormSubmit : true });
        //   }
        // });
        ModalDialog.open('<div>asdf</div>', { ignoreFormSubmit : true });
      }else{
    
      }
    })
  }
  
};

// Provide a pretty shortcut
Organizations = Application.Helpers.Organizations;
