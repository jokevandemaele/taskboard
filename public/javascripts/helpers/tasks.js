Application.Helpers.Tasks = {
  initialize: function(){
    this.setupListeners();
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
  },

  removeTask: function(projectId,storyId,taskId){
    new Ajax.Request('/projects/'+projectId+'/stories/'+storyId+'/tasks/'+taskId, {
      method: 'delete',
        
      onSuccess: function(transport) {
        $('task-'+taskId+'-project-'+projectId+'-li').fade({ duration : 0.2});
      }
    });
  },

  flip: function(taskId){
    if($('task-'+taskId+'-front').visible()){
      $('task-'+taskId+'-front').fade({duration : 0.1});
      $('task-'+taskId+'-back').appear({duration : 0.1});
    }else{
      $('task-'+taskId+'-front').appear({duration : 0.1});
      $('task-'+taskId+'-back').fade({duration : 0.1});
    }
  },
  
  toggleTasks: function(tasks){
    counter = 0;
    tasks.each(function(element){
      if(counter < 3){
        element.show();
      }else{
        if(element.visible()){
          element.fade({duration : 0.3});
          element.blindUp({duration : 0.2});
        }else{
          element.appear({duration : 0.3});
          element.blindDown({duration : 0.2});
        }
      }
      counter++;
    });
  },
  
  setupListeners: function(){
    $('taskboard').observe('click', function(event){
      var target = event.element();
      // Listener for hovering finished tasks list
      if(target.match('.finished_tasks')){
        Tasks.toggleTasks(target.childElements());
      }
    });
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
