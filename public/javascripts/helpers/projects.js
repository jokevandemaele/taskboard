Application.Helpers.Projects = {
  initialize: function(){
    this._setupListeners();
  },
  
  newForm: function(organizationId){
    // Request form
    new Ajax.Request('/organizations/'+ organizationId + '/projects/new', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterCreate: function(response){
    var project = response.evalJSON().project
    new Ajax.Request('/organizations/' + project.organization_id + '/projects/' + project.id, {
      method: 'get',
        
      onSuccess: function(transport) {
        var container = new Element('div').update(transport.responseText);
        var project_container = container.down('.project')
        
        $('organization-'+ project.organization_id).down('.list.projects').insert({bottom: project_container});
        Effect.ScrollTo(project_container, { duration: 0.2, afterFinish: project_container.highlight({ duration: 0.8 }) })
      }
    });
    ModalDialog.close();
  },
  
  editForm: function(project, organization){
    organizationId = organization.readAttribute('data-organization-id');
    projectId = project.readAttribute('data-project-id');
    new Ajax.Request('/organizations/'+organizationId+'/projects/'+projectId+'/edit', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterUpdate: function(response){
    ModalDialog.close();
    var project = response.evalJSON().project
    var project_container = $('project-' + project.id)
    var name = project_container.down('.name')
    name.innerHTML = project.name;
    Effect.ScrollTo(project_container, { duration: 0.2, afterFinish: project_container.highlight({ duration: 0.8 }) })
    
    
  },
  
  deleteProject: function(project, organization){
    organizationId = organization.readAttribute('data-organization-id');
    projectId = project.readAttribute('data-project-id');
    new Ajax.Request('/organizations/' + organizationId + '/projects/' + projectId, {
      method: 'delete',
        
      onSuccess: function(transport) {
        project.setStyle({'z-index' : 200});
        Effect.Fade(project);
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

      // Listener for add project
      if(target.match('.new_project')){
        organizationId = target.up('.organization').readAttribute('data-organization-id');
        Projects.newForm(organizationId);
      }

      // Listener for remove project
      if(target.match('.remove_project')){
        organization = target.up('.organization');
        project = target.up('.project');
        ModalDialog.yes_no("Are you sure?", function() { Projects.deleteProject(project, organization) })
      }
      
      // Listener for edit project
      if(target.match('.edit_project')){
        organization = target.up('.organization');
        project = target.up('.project');
        Projects.editForm(project, organization);
      }
      
    });
  }
};

// Provide a pretty shortcut
Projects = Application.Helpers.Projects;
