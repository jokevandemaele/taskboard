# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def admin_open_div(size, options = {})
    "<div id=\"#{options[:id]}\" class=\"admin-div-top #{options[:class]}\" style=\"width: #{size}px; #{options[:style]}\"><span class=\"admin-div-top-left\"></span><span class=\"admin-div-top-middle\" style=\"width: #{size - 30}px\"></span><span class=\"admin-div-top-right\"></span></div>
    <div class=\"admin-div-content\" style=\"width: #{size-30}px\">"
  end

  def admin_close_div(size)
    "</div>
    <div class=\"admin-div-bottom\" style=\"width: #{size}px\"><span class=\"admin-div-bottom-left\"></span><span class=\"admin-div-bottom-middle\" style=\"width: #{size-30}px\"></span><span class=\"admin-div-bottom-right\"></span></div>"
  end
  
  def admin_form_name(element,edit, f, no_refresh = nil)
    element_class = element.class.to_s
    name = (element.name) ? element.name : "Click To Edit #{element_class} Name"
		f.text_field :name, 
			:value => h(name), 
			:class => "form-name name-field", 
			:onClick => "if(this.value == 'Click To Edit #{element_class} Name' ) this.clear();" 
  end
  def admin_form_buttons(element)
    element_class = element.class.to_s.downcase
    "<div style='float: right; position:relative; top: 20px;'>
		#{image_submit_tag 'admin/admin-form-submit.png', :alt => 'Submit', :style => "width: 50px;"}
		#{image_tag 'admin/admin-form-cancel.png', :alt => 'Cancel', :style => "width: 45px;", :class => 'admin-form-cancel', :onClick => 'cancelForm(\'form-add-'+ element_class +'\');'}
		</div>"
  end
  
  def show_admin_info_for(member, parent)
    return image_tag("admin/admin-div-element-sysadmin.png", 
                      :alt => "sysadmin", 
                      :id => "organization-#{parent.id}-member-#{member.id}-admin", 
                      :class => "admin-div-element-actions-edit-admin#{'-left-aligned' if !current_member.admin?}", :title => "System Administrator") if member.admin?

    action = member.admins?(parent) ? "remove" : "make"

    if(current_member.admins?(parent) && (current_member.id != member.id))
      link_to_remote image_tag("admin/admin-div-element-#{action}-admin.png", 
              :alt => "Toggle admin", 
              :title => "Toggle admin", 
              :id => "organization-#{parent.id}-member-#{member.id}-admin", 
              :class => "admin-div-element-actions-edit-admin"),
            :url => { 
              :controller => 'admin/organizations', 
              :action => 'toggle_admin', 
              :id => parent, 
              :member => member },
            :success => "adminToggleImage('organization-#{parent.id}-member-#{member.id}-admin')"
    else
      title = (action == "remove") ? "Organization Admin" : "Normal User"
      image_tag("admin/admin-div-element-#{action}-admin.png", 
              :alt => title, 
              :title => title, 
              :id => "organization-#{parent.id}-member-#{member.id}-admin", 
              :class => "admin-div-element-actions-edit-admin#{'-left-aligned' if !current_member.admins?(parent)}")
    end 
  end

end
