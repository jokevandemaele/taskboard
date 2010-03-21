Application.Helpers.GuestTeamMembers = {
  initialize: function(){
    this._setupListeners();
  },
  
  newForm: function(organizationId){
    // Request form
    new Ajax.Request('/organizations/'+ organizationId + '/guest_team_memberships/new', {
      method: 'get',
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },

  newFormWithMail: function(organizationId){
    // Request form
    new Ajax.Request('/organizations/'+ organizationId + '/guest_team_memberships/new', {
      method: 'get',
      parameters: 'email=' + $('email').value,
        
      onSuccess: function(transport) {
        var formContainer = new Element('div', { id : 'form_container'}).update(transport.responseText);
        ModalDialog.open(formContainer, { ignoreFormSubmit : true });
      }
    });
  },

  createGuestTeamMembers: function(organizationId){
    
    $$('.project_checkbox').each(function(checkbox){
      if(checkbox.checked){
        new Ajax.Request('/organizations/'+ organizationId + '/projects/'+checkbox.value+'/guest_team_memberships', {
          method: 'post',
          parameters: 'email=' + $('email').value,

          onSuccess: function(transport) {
            guest_team_member = transposrt.responseJSON
            alert(guest_team_member);
            // $('organization-'+organizationId).down('.list.')
          },
          
          onFailure: function(transport){
            ModalDialog.displayFormErrors(transport.responseJSON);
            return
          }
        });
      }
    });
  },
  
  // afterCreate: function(response){
  //   var guest_team_member = response.evalJSON().guest_team_member
  //   new Ajax.Request('/organizations/' + guest_team_member.organization_id + '/guest_team_members/' + guest_team_member.id, {
  //     method: 'get',
  //       
  //     onSuccess: function(transport) {
  //       var container = new Element('div').update(transport.responseText);
  //       var guest_team_member_container = container.down('.guest_team_member')
  //       
  //       $('organization-'+ guest_team_member.organization_id).down('.list.guest_team_members').insert({bottom: guest_team_member_container});
  //       guest_team_member_container.highlight({ duration: 0.8 });
  //     }
  //   });
  //   ModalDialog.close();
  // },
  // 
  // editForm: function(guest_team_member, organization){
  //   organizationId = organization.readAttribute('data-organization-id');
  //   guest_team_memberId = guest_team_member.readAttribute('data-guest_team_member-id');
  //   new Ajax.Request('/organizations/'+organizationId+'/guest_team_members/'+guest_team_memberId+'/edit', {
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
  //   var guest_team_member = response.evalJSON().guest_team_member
  //   var guest_team_member_container = $('guest_team_member-' + guest_team_member.id)
  //   var name = guest_team_member_container.down('.name')
  //   name.innerHTML = guest_team_member.name;
  //   guest_team_member_container.highlight({ duration: 0.8 });
  // },
  // 
  // deleteGuestTeamMember: function(guest_team_member, organization){
  //   organizationId = organization.readAttribute('data-organization-id');
  //   guest_team_memberId = guest_team_member.readAttribute('data-guest_team_member-id');
  //   new Ajax.Request('/organizations/' + organizationId + '/guest_team_members/' + guest_team_memberId, {
  //     method: 'delete',
  //       
  //     onSuccess: function(transport) {
  //       guest_team_member.setStyle({'z-index' : 200});
  //       Effect.Fade(guest_team_member);
  //     }
  //   });
  // },
  // 
  // hideAllGuestTeamMembers: function(){
  //   $$('.guest_team_member_info').each(function(guest_team_memberInfo){
  //     guest_team_memberInfo.hide();
  //   });
  // },
  // 
  // displayGuestTeamMemberInfo: function(guest_team_member, organization){
  //   this.hideAllGuestTeamMembers();
  //   guest_team_memberId = guest_team_member.readAttribute('data-guest_team_member-id');
  //   guest_team_memberInfoDiv = $('guest_team_member-info-' + guest_team_memberId);
  //   if(!guest_team_memberInfoDiv){
  //     organizationId = organization.readAttribute('data-organization-id');
  //     new Ajax.Request('/organizations/'+organizationId+'/guest_team_members/'+guest_team_memberId+'/guest_team_member_info', {
  //       method: 'get',
  //     
  //       onSuccess: function(transport) {
  //         guest_team_memberInfoDiv = new Element('div', { id : 'guest_team_member-info-'+guest_team_memberId, 'class' : 'guest_team_member_info admin_container'}).update(transport.responseText);
  //         $('admin-content').insert({top: guest_team_memberInfoDiv});
  //         GuestTeamMembers.displayGuestTeamMemberInfo(guest_team_member,organization)
  //       }
  //     });
  //   }else{
  //     var top = organization.cumulativeOffset().top - $('admin-content').cumulativeOffset().top + 10
  //     guest_team_memberInfoDiv.setStyle({ position: 'absolute', top: top + 'px', left: '-' + (guest_team_memberInfoDiv.getWidth() + 10) + 'px'});
  //     guest_team_memberInfoDiv.show();
  //   }
  // },
  // 
  // hideGuestTeamMemberInfo: function(guest_team_member){
  //   $('guest_team_member-info-' + guest_team_memberId).hide();
  // },
  // 
  // addUser: function(user){
  //   user.fade()
  //   var organizationId = user.readAttribute('data-organization-id');
  //   var guest_team_memberId = user.readAttribute('data-guest_team_member-id');
  //   var userId = user.readAttribute('data-user-id');
  //   var userName = user.readAttribute('data-user-name');
  //   var userAvatar = user.readAttribute('data-user-avatar');
  //   var userNametag = user.readAttribute('data-user-nametag');
  //   var userContainer = new Element('div', { 'class' : 'user', 'data-user-name' : userName, 'data-user-avatar' : userAvatar, 'data-user-nametag' : userNametag, 'data-organization-id' : organizationId, 'data-guest_team_member-id' : guest_team_memberId, 'data-user-id' : userId})
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
  //   userContainer.insert({bottom: new Element('div', {'class': 'remove', 'title' : 'Remove From GuestTeamMember'})})
  //   
  //   userContainer.hide();
  //   $('guest_team_member_users').insert({bottom: userContainer});
  //   userContainer.appear();
  //   new Ajax.Request('/organizations/'+organizationId+'/guest_team_members/'+guest_team_memberId+'/users/'+userId, {method: 'post'});
  // },
  // 
  // removeUser: function(user){
  //   user.fade()
  //   var organizationId = user.readAttribute('data-organization-id');
  //   var guest_team_memberId = user.readAttribute('data-guest_team_member-id');
  //   var userId = user.readAttribute('data-user-id');
  //   var userName = user.readAttribute('data-user-name');
  //   var userAvatar = user.readAttribute('data-user-avatar');
  //   var userNametag = user.readAttribute('data-user-nametag');
  //   var userContainer = new Element('div', { 'class' : 'user', 'data-user-name' : userName, 'data-user-avatar' : userAvatar, 'data-user-nametag' : userNametag, 'data-organization-id' : organizationId, 'data-guest_team_member-id' : guest_team_memberId, 'data-user-id' : userId})
  // 
  //   // Add the name
  //   var nameContainer = new Element('div', {'class' : 'name'}).update(userName);
  //   userContainer.insert({bottom: nameContainer});
  // 
  //   // Add Add Button
  //   userContainer.insert({bottom: new Element('div', {'class': 'add'}).update('add to guest_team_member')})
  //   
  //   userContainer.hide();
  //   $('organization_users').insert({bottom: userContainer});
  //   userContainer.appear();
  //   
  //   new Ajax.Request('/organizations/'+organizationId+'/guest_team_members/'+guest_team_memberId+'/users/'+userId, {method: 'delete'});
  // },
  // 
  _setupListeners: function(){
    // Organization List Listeners
    this._organizationListListener();
  },
  
  // Handles the creation of the observers for edit and remove 
  _organizationListListener: function(){
    // Observe clicks on edit and remove buttons for guest_team_members
    if($('organizations')){
      $("organizations").observe('click', function(event){
        var target = event.element();

        // Listener for add guest_team_member
        if(target.match('.new_guest_team_member')){
          organizationId = target.up('.organization').readAttribute('data-organization-id');
          GuestTeamMembers.newForm(organizationId);
        }

        // Listener for remove guest_team_member
        if(target.match('.remove_guest_team_member')){
          organization = target.up('.organization');
          guest_team_member = target.up('.guest_team_member');
          ModalDialog.yes_no("Are you sure?", function() { GuestTeamMembers.deleteGuestTeamMember(guest_team_member, organization) })
        }

        // Listener for edit guest_team_member
        if(target.match('.edit_guest_team_member')){
          organization = target.up('.organization');
          guest_team_member = target.up('.guest_team_member');
          GuestTeamMembers.editForm(guest_team_member, organization);
        }

      });
    }
  }
};

// Provide a pretty shortcut
GuestTeamMembers = Application.Helpers.GuestTeamMembers;
