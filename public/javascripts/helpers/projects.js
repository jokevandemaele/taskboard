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
        project_container.highlight({ duration: 0.8 });
        
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

    // Update project name
    var name = project_container.down('.name')
    var nameElement = new Element('a', { href : '/projects/' + project.id + '/taskboard'})
    nameElement.innerHTML = project.name;
    name.innerHTML = ''
    name.appendChild(nameElement);

    // Update project public status
    var adminProject = project_container.down('.admin');
    if(project.public){
      project_container.writeAttribute('data-project-public-hash', project.public_hash);
      if(!adminProject.down('.public_project')){
        var lock = new Element('div', {'class' : 'public_project', 'title' : 'Public Project'})
        adminProject.appendChild(lock);
      }
    }else{
      var lock = adminProject.down('.public_project')
      if(lock){
        lock.remove();
      }
    }
    project_container.highlight({ duration: 0.8 });
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
  
  showPublicHash: function(project){
    var publicHash = project.readAttribute('data-project-public-hash');
    var projectId = project.readAttribute('data-project-id');
    if(publicHash){
      var container = new Element('div');
      var publicHashText = new Element('p', { 'class' : 'public_hash_container'}).update("Public Hash: <strong>" + publicHash + "</strong>");
      container.appendChild(publicHashText);
      var publicHashLink = new Element('p', { 'class' : 'public_hash_container'}).update("Public Link: <a href='/projects/"+projectId+"/taskboard?public_hash=" + publicHash+"'>Click Here</a>");
      container.appendChild(publicHashLink);
      ModalDialog.open(container, { ignoreFormSubmit : true });
    }
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
        var organizationId = target.up('.organization').readAttribute('data-organization-id');
        Projects.newForm(organizationId);
      }

      // Listener for remove project
      if(target.match('.remove_project')){
        var organization = target.up('.organization');
        var project = target.up('.project');
        ModalDialog.yes_no("Are you sure?", function() { Projects.deleteProject(project, organization) })
      }
      
      // Listener for edit project
      if(target.match('.edit_project')){
        var organization = target.up('.organization');
        var project = target.up('.project');
        Projects.editForm(project, organization);
      }

      // Listener for public project
      if(target.match('.public_project')){
        var project = target.up('.project');
        Projects.showPublicHash(project);
      }
    });
  }
};

// Provide a pretty shortcut
Projects = Application.Helpers.Projects;
