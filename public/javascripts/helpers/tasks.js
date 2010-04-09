Application.Helpers.Tasks = {
  initialize: function(){
  },
  
  newForm: function(projectId,storyId){
    // Request form
    new Ajax.Request('/projects/'+ projectId + '/stories/'+storyId+'/tasks/new', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },
  
  afterCreate: function(response){
    var response = response.evalJSON();
    var story = response.story
    var project = response.project
    new Ajax.Request('/stories/tasks_by_status/+'+story+'?project_id='+project+'&status=not_started', {
      method: 'get',
        
      onSuccess: function(transport) {
        $('not_started-'+story).update(transport.responseText);
      }
    });
    ModalDialog.close();
  }
  // 
  // editForm: function(Task, organization){
  //   organizationId = organization.readAttribute('data-organization-id');
  //   TaskId = Task.readAttribute('data-Task-id');
  //   new Ajax.Request('/organizations/'+organizationId+'/Tasks/'+TaskId+'/edit', {
  //     method: 'get',
  //       
  //     onSuccess: function(transport) {
  //       var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
  //       ModalDialog.open(formContainer, { ignoreFormSubmit : true });
  //     }
  //   });
  // },
  // 
  // afterUpdate: function(response){
  //   ModalDialog.close();
  //   var Task = response.evalJSON().Task
  //   var Task_container = $('Task-' + Task.id)
  //   var name = Task_container.down('.name')
  //   name.innerHTML = Task.name;
  //   Task_container.highlight({ duration: 0.8 });
  // },
};

// Provide a pretty shortcut
Tasks = Application.Helpers.Tasks;
