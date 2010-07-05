 
(function() { 
 
var Dom = YAHOO.util.Dom; 
var Event = YAHOO.util.Event; 
var DDM = YAHOO.util.DragDropMgr; 
 
////////////////////////////////////////////////////////////////////////////// 
// custom drag and drop implementation for tasks
////////////////////////////////////////////////////////////////////////////// 
	 
	YAHOO.example.DDList = function(id, sGroup, config) { 
	 
	    YAHOO.example.DDList.superclass.constructor.call(this, id, sGroup, config); 
	 
	    this.logger = this.logger || YAHOO; 
	    var el = this.getDragEl(); 
	    //Dom.setStyle(el, "opacity", 0.67); // The proxy is slightly transparent 
	 
	    this.goingUp = false; 
	    this.lastY = 0; 
	}; 
	 
	YAHOO.extend(YAHOO.example.DDList, YAHOO.util.DDProxy, { 
	 
	    startDrag: function(x, y) { 
	        //this.logger.log(this.id + " startDrag"); 
	 
	        // make the proxy look like the source element 
	        var dragEl = this.getDragEl(); 
	        var clickEl = this.getEl(); 
	        Dom.setStyle(clickEl, "visibility", "hidden"); 
	        dragEl.innerHTML = clickEl.innerHTML; 
          // Dom.setStyle(dragEl, "color", Dom.getStyle(clickEl, "color")); 
          // Dom.setStyle(dragEl, "backgroundColor", Dom.getStyle(clickEl, "backgroundColor")); 
          Dom.removeClass(dragEl, dragEl.className);
          Dom.setStyle(dragEl, "border", "0px");
	        Dom.addClass(dragEl, 'task')
          Dom.setStyle(dragEl, "width", "126px");
          Dom.setStyle(dragEl, "height", "126px");
          Dom.setStyle(dragEl, "background-color", clickEl.getStyle('background-color'));
          Dom.setStyle(dragEl, "background-image", clickEl.getStyle('background-image'));
	    }, 
	 
	    endDrag: function(e) { 
          var srcEl = this.getEl(); 
          var proxy = this.getDragEl(); 

          // Show the proxy element and animate it to the src element's location 
          Dom.setStyle(proxy, "visibility", ""); 
          var a = new YAHOO.util.Motion(  
              proxy, {  
                  points: {  
                      to: Dom.getXY(srcEl) 
                  } 
              },  
              0.2,  
              YAHOO.util.Easing.easeOut  
          ) 
          var proxyid = proxy.id; 
          var thisid = this.id; 
          // Hide the proxy and show the source element when finished with the animation 
          a.onComplete.subscribe(function() { 
                  Dom.setStyle(proxyid, "visibility", "hidden"); 
                  $(proxyid).innerHTML = '';
                  Dom.setStyle(thisid, "visibility", "");
                  if($(thisid).parentNode.id == 'table-list'){
                    var status_name = $(thisid).parentNode.parentNode.parentNode.parentNode.parentNode.id.split('-');
                  }else{
                    var status_name = $(thisid).parentNode.id.split('-');
                  }
                  var projectId = $(srcEl).up('.story_holder').readAttribute('data-project-id');
                  
                  if(status_name[0] == 'finished'){
                    new Ajax.Updater('finished-'+status_name[1], '/stories/tasks_by_status/'+status_name[1]+'?status=finished&project_id='+projectId, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + getAuthKey()})
                  }
                  // new Ajax.Updater(thisid, '/tasks/'+$(thisid).id.split('-')[1], {asynchronous:false, method:'get',evalScripts:true, parameters:'authenticity_token=' + getAuthKey()})
              }); 
          a.animate();
	    }, 
	 
	    onDragDrop: function(e, id) { 
	        // If there is one drop interaction, the li was dropped either on the list, 
	        // or it was dropped on the current location of the source element. 
	//        if (DDM.interactionInfo.drop.length >= 2) { 
	            // The position of the cursor at the time of the drop (YAHOO.util.Point) 
	            var pt = DDM.interactionInfo.point;  
	 
	            // The region occupied by the source element at the time of the drop 
	            var region = DDM.interactionInfo.sourceRegion;  
	 
	            // Check to see if we are over the source element's location.  We will 
	            // append to the bottom of the list once we are sure it was a drop in 
	            // the negative space (the area of the list without any list items) 
	            //if (!region.intersect(pt)) {
                var destEl = Dom.get(id); 
                var status_name = destEl.id.split('-');
                var destDD = DDM.getDDById(id); 
                var srcEl = this.getEl();
                var refresh = false;
                if(status_name[0] == 'not_started' || status_name[0] == 'in_progress' || status_name[0] == 'finished'){
                  if(srcEl.up('td.finished_tasks')){
                    refresh = true;
                    var parent_name = srcEl.parentNode.parentNode.parentNode.parentNode.parentNode.id.split('-');
                  }
                  
	                destEl.appendChild(srcEl);
	                destDD.isEmpty = false; 
	                DDM.refreshCache();
	                // Now we should make the ajax call
	                var element_name = srcEl.id.split('-');
	                var storyId = $(destEl).up('.story_holder').readAttribute('data-story-id');
	                var currentStoryId = $(srcEl).readAttribute('data-story-id');
                  var projectId = $('story-'+ storyId).readAttribute('data-project-id');
                  var currentProjectId = $('story-'+ currentStoryId).readAttribute('data-project-id');
	                var taskId = $(srcEl).readAttribute('data-task-id');
	                var action = $(destEl).readAttribute('data-action');
	                
                  new Ajax.Request('/projects/'+currentProjectId+'/stories/'+currentStoryId+'/tasks/'+taskId+'/'+action, {asynchronous:true, evalScripts:true, parameters: 'new_story_id='+ storyId + '&authenticity_token=' + getAuthKey()})
	                $(srcEl).writeAttribute('data-story-id', storyId);
                  
                  
                  // new Ajax.Request('/tasks/update_task', {asynchronous:true, evalScripts:true, parameters:'task=' + (element_name[1]) + '&status=' + status_name[0] +'&story='+status_name[1] + '&authenticity_token=' + getAuthKey()})
                  if(refresh){
                    new Ajax.Updater('finished-'+parent_name[1], '/stories/tasks_by_status/'+parent_name[1]+'?status=finished&project_id='+projectId, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + getAuthKey()})
                    new Ajax.Updater(status_name[0]+'-'+status_name[1], '/stories/tasks_by_status/'+status_name[1]+'?status='+status_name[0]+'&project_id='+projectId, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + getAuthKey()})
                  }
	              }
	           // } 
	     //   } 
	    }, 
	 
	    onDrag: function(e) { 
	 
	        // Keep track of the direction of the drag for use during onDragOver 
	        var y = Event.getPageY(e); 
	 
	        if (y < this.lastY) { 
	            this.goingUp = true; 
	        } else if (y > this.lastY) { 
	            this.goingUp = false; 
	        } 
	 
	        this.lastY = y; 
	    }, 
	 
	    // onDragOver: function(e, id) { 
	    //  
	    //     var srcEl = this.getEl(); 
	    //     var destEl = Dom.get(id); 
	    // 	 
	    //     // We are only concerned with list items, we ignore the dragover 
	    //     // notifications for the list. 
	    //     if (destEl.nodeName.toLowerCase() == "li") { 
	    //         var orig_p = srcEl.parentNode; 
	    //         var p = destEl.parentNode; 
	    //         //var refresh = false;
	    // 
	    //               // if(srcEl.parentNode.id == 'table-list'){
	    //               //   refresh = true;
	    //               //   var parent_name = srcEl.parentNode.parentNode.parentNode.parentNode.parentNode.id.split('-');
	    //               // }
	    //               // 	    
	    // 									// 	            if (this.goingUp) { 
	    // 									// 	                p.insertBefore(srcEl, destEl); // insert above 
	    // 									// 	            } else { 
	    // 									// p.insertBefore(srcEl, destEl.nextSibling); // insert below 
	    // 									// 	            } 
	    //               // // Now we should make the ajax call
	    //               // var element_name = srcEl.id.split('-');
	    //               // if(p.id != 'table-list'){
	    //               //   var status_name = p.id.split('-');
	    //               // }else{
	    //               //   var status_name = p.parentNode.parentNode.parentNode.parentNode.id.split('-');
	    //               // }
	    //               // var refresh = false;
	    //               // if(srcEl.parentNode.id == 'table-list'){
	    //               //   refresh = true;
	    //               //   var parent_name = srcEl.parentNode.parentNode.parentNode.parentNode.parentNode.id.split('-');
	    //               // }
	    //               // 
	    //               // if(element_name[0] == 'task' && (status_name[0] == 'not_started' || status_name[0] == 'in_progress' || status_name[0] == 'finished')){
	    //               //   new Ajax.Request('/tasks/update_task', {asynchronous:true, evalScripts:true, parameters:'task=' + (element_name[1]) + '&status=' + status_name[0] +'&story='+status_name[1] + '&authenticity_token=' + getAuthKey()})
	    //               //   if(refresh){
	    //               //     new Ajax.Updater('finished-'+parent_name[1], '/stories/tasks_by_status/'+parent_name[1]+'?status=finished', {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + getAuthKey()})
	    //               //     new Ajax.Updater(status_name[0]+'-'+status_name[1], '/stories/tasks_by_status/'+status_name[1]+'?status='+status_name[0], {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + getAuthKey()})
	    //               //   }
	    //               // }
	    //             
	    //         DDM.refreshCache(); 
	    //     } 
	    // } 
	}); 
	
  ////////////////////////////////////////////////////////////////////////////// 
  // custom drag and drop implementation for updating and removing tags
  ////////////////////////////////////////////////////////////////////////////// 
  
       YAHOO.DDTags = function(id, sGroup, config) { 
  
           YAHOO.DDTags.superclass.constructor.call(this, id, sGroup, config); 
  
           this.logger = this.logger || YAHOO; 
           var el = this.getDragEl();
  
           this.goingUp = false; 
           this.lastY = 0; 
       }; 
    
    YAHOO.extend(YAHOO.DDTags, YAHOO.util.DDProxy, { 
       startDrag: function(x, y) { 
         //this.logger.log(this.id + " startDrag"); 
 
         // make the proxy look like the source element 
         var dragEl = this.getDragEl(); 
         var clickEl = this.getEl(); 
         Dom.setStyle(clickEl, "visibility", "hidden"); 
 
         dragEl.innerHTML = clickEl.innerHTML;
         if(Dom.hasClass(clickEl,'statustag')){
           Dom.removeClass(dragEl, dragEl.className)
           if(Dom.hasClass(clickEl, 'statustag-done')){ Dom.addClass(dragEl, 'statustag-done')}
           if(Dom.hasClass(clickEl, 'statustag-blocked')){ Dom.addClass(dragEl, 'statustag-blocked')}
           if(Dom.hasClass(clickEl, 'statustag-high_priority')){ Dom.addClass(dragEl, 'statustag-high_priority')}
           if(Dom.hasClass(clickEl, 'statustag-waiting')){ Dom.addClass(dragEl, 'statustag-waiting')}
           if(Dom.hasClass(clickEl, 'statustag-delegated')){ Dom.addClass(dragEl, 'statustag-delegated')}
           if(Dom.hasClass(clickEl, 'statustag-bug')){ Dom.addClass(dragEl, 'statustag-bug')}
           if(Dom.hasClass(clickEl, 'statustag-please_analyze')){ Dom.addClass(dragEl, 'statustag-please_analyze')}
           if(Dom.hasClass(clickEl, 'statustag-please_test')){ Dom.addClass(dragEl, 'statustag-please_test')}
           Dom.setStyle(dragEl, "border", "none"); 
           Dom.setStyle(dragEl, "width", "50px");
           Dom.setStyle(dragEl, "height", "37px");
         }else{
           Dom.removeClass(dragEl, dragEl.className);
           Dom.addClass(dragEl, 'nametag')
           Dom.setStyle(dragEl, "border", "none"); 
           Dom.setStyle(dragEl, "min-width", "58px");
           Dom.setStyle(dragEl, "height", "12px");
           Dom.setStyle(dragEl, "background-color", clickEl.getStyle('background-color'));
           Dom.setStyle(dragEl, "background-image", clickEl.getStyle('background-image'));
         }
       },

      onDragDrop: function(e, id) {
        var destEl = Dom.get(id); 
        var destDD = DDM.getDDById(id); 
        var srcEl = this.getEl();
        var element_name = srcEl.id.split('-');
        var dest_name = destEl.id.split('-');
        
        if (DDM.interactionInfo.drop.length > 1) { 
          // The position of the cursor at the time of the drop (YAHOO.util.Point) 
          var pt = DDM.interactionInfo.point;
          
          // The region occupied by the source element at the time of the drop 
          var region = DDM.interactionInfo.sourceRegion;
          var drag_region = DDM.interactionInfo.draggedRegion;
          // Check to see if we are over the source element's location.
          // Now we should make the ajax call
          var element_name = srcEl.id.split('-');
          var dest_name = destEl.id.split('-');
          if (dest_name[0] == 'task'){
            var x = drag_region.left - $(destEl.id).cumulativeOffset().left
            var y = drag_region.top - $(destEl.id).cumulativeOffset().top
            var projectId = srcEl.up('tr').readAttribute('data-project-id');
            var storyId = srcEl.up('tr').readAttribute('data-story-id');
            var taskId = srcEl.up('.task').readAttribute('data-task-id');
            var newTaskId = destEl.readAttribute('data-task-id');
            
            new Ajax.Request('/projects/'+projectId+'/stories/'+storyId+'/tasks/'+taskId+'/'+element_name[0]+'s/'+element_name[3], 
            {
              asynchronous:true, 
              method:'put', 
              parameters: element_name[0]+'[task_id]='+ newTaskId + '&' + element_name[0]+'[relative_position_x]='+ x + '&'+element_name[0]+'[relative_position_y]='+ y + '&authenticity_token=' + getAuthKey(),
              onSuccess: function(){
                destEl.down('.task_front').appendChild(srcEl);
                srcEl.pulsate({pulses: 2, duration : 0.8});
              }
            }
            
            )
            srcEl.parentNode.removeChild(srcEl);
            destEl.appendChild(srcEl);
						DDM.refreshCache();
          }
        }else{
          var projectId = srcEl.up('tr').readAttribute('data-project-id');
          var storyId = srcEl.up('tr').readAttribute('data-story-id');
          var taskId = srcEl.up('.task').readAttribute('data-task-id');
          
          if(dest_name[0] != 'task'){
          new Ajax.Request('/projects/'+projectId+'/stories/'+storyId+'/tasks/'+taskId+'/'+element_name[0]+'s/'+element_name[3], {
          asynchronous:true, 
          evalScripts:true,  
          method:'delete',
          parameters:'project_id='+element_name[2]+'&authenticity_token=' + getAuthKey()})
          var anim = new YAHOO.util.Anim(srcEl.id, { opacity: { to: 0 }, duration: 0.5 });
          anim.onComplete.subscribe(function(srcEl) { 
            srcEl.parentNode.removeChild(srcEl);
          });
          anim.animate();
          }
        }
      }, 
    });


	  ////////////////////////////////////////////////////////////////////////////// 
	  // custom drag and drop implementation for adding tags
	  ////////////////////////////////////////////////////////////////////////////// 

       YAHOO.DDAddTags = function(id, sGroup, config) { 

           YAHOO.DDAddTags.superclass.constructor.call(this, id, sGroup, config); 

           this.logger = this.logger || YAHOO; 
           var el = this.getDragEl();

           this.goingUp = false; 
           this.lastY = 0; 
       }; 

	    YAHOO.extend(YAHOO.DDAddTags, YAHOO.util.DDProxy, { 
		    endDrag: function(e) { 
			    var proxy = this.getDragEl();
          Dom.setStyle(proxy, "visibility", "hidden"); 
	      },
	       startDrag: function(x, y) { 
	         // make the proxy look like the source element 
	         var dragEl = this.getDragEl(); 
	         var clickEl = this.getEl(); 
	         dragEl.innerHTML = clickEl.innerHTML;
	         if(Dom.hasClass(clickEl,'statustag')){
	           Dom.removeClass(dragEl, dragEl.className)
	           if(Dom.hasClass(clickEl, 'statustag-done')){ Dom.addClass(dragEl, 'statustag-done')}
	           if(Dom.hasClass(clickEl, 'statustag-blocked')){ Dom.addClass(dragEl, 'statustag-blocked')}
	           if(Dom.hasClass(clickEl, 'statustag-high_priority')){ Dom.addClass(dragEl, 'statustag-high_priority')}
	           if(Dom.hasClass(clickEl, 'statustag-waiting')){ Dom.addClass(dragEl, 'statustag-waiting')}
	           if(Dom.hasClass(clickEl, 'statustag-delegated')){ Dom.addClass(dragEl, 'statustag-delegated')}
	           if(Dom.hasClass(clickEl, 'statustag-bug')){ Dom.addClass(dragEl, 'statustag-bug')}
	           if(Dom.hasClass(clickEl, 'statustag-please_analyze')){ Dom.addClass(dragEl, 'statustag-please_analyze')}
	           if(Dom.hasClass(clickEl, 'statustag-please_test')){ Dom.addClass(dragEl, 'statustag-please_test')}
	           Dom.setStyle(dragEl, "border", "none"); 
	           Dom.setStyle(dragEl, "width", "50px");
	           Dom.setStyle(dragEl, "height", "37px");
	         }else{
	           Dom.removeClass(dragEl, dragEl.className);
	           Dom.addClass(dragEl, 'nametag')
	           Dom.setStyle(dragEl, "border", "none"); 
	           Dom.setStyle(dragEl, "width", "60px");
	           Dom.setStyle(dragEl, "height", "12px");
	           Dom.setStyle(dragEl, "background-color", clickEl.getStyle('background-color'));
	         }
	       },

	      onDragDrop: function(e, id) {
	        var destEl = Dom.get(id); 
	        var destDD = DDM.getDDById(id); 
	        var srcEl = this.getEl();
	        var dragEl = this.getDragEl();
         	var clickEl = this.getEl();
	        var element_name = srcEl.id.split('-');
	        var dest_name = destEl.id.split('-');
          var drag_region = DDM.interactionInfo.draggedRegion;
          var specific_parameter = ''
          
          if(element_name[1] == 'statustag')
            specific_parameter = 'statustag[status]';
          if(element_name[1] == 'nametag')
            specific_parameter = 'nametag[user_id]';

          if((element_name[1] == 'statustag' || element_name[1] == 'nametag') && dest_name[0] == 'task'){
            // Update database
            var x = drag_region.left - $(destEl.id).cumulativeOffset().left - 4;
            var y = drag_region.top - $(destEl.id).cumulativeOffset().top;
            var projectId = destEl.up('tr').readAttribute('data-project-id');
            var storyId = destEl.up('tr').readAttribute('data-story-id');
            var taskId = destEl.readAttribute('data-task-id');
            
            new Ajax.Request('/projects/'+projectId+'/stories/'+storyId+'/tasks/'+taskId+'/'+element_name[1]+'s/', {
              method:'post', 
              parameters:'statustag[relative_position_x]='+ (x+4) + '&statustag[relative_position_y]='+ y + '&'+specific_parameter+"="+ element_name[2]+ '&authenticity_token=' + getAuthKey(),
              onSuccess: function(transport) {
                var tmp = new Element('div').update(transport.responseText);
                destEl.down('.task_front').appendChild(tmp);
                tmp.pulsate({pulses: 2, duration : 0.8});
              },
            });
          }else{
            //Dom.setStyle(dragEl, "visibility", "hidden"); 
          }
        }, 
      });


  })(); 

  
