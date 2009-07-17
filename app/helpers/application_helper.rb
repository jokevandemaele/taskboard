# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	# get_initials_of: 
	#	this functions gives the initials of a string.
	#	if the string is null, we return null
	#	if the string has one word, we return the first two characters
	# 	if the string has more whan one word, we return the first character of each word
	#	you can use the limit variable to set the maximum number of initials to return
	def get_initials_of(string,limit = 0)
		if string.empty?
			return ""
		end

		initials = String.new
		words = string.split

		if words.size == 1
			if words[0].length > 2
				initials << words[0][0] << words[0][1]
			else
				initials << words[0][0]
			end	
		else
			words.each do |word|		
				initials << word[0]
			end
		end
		if limit > 0
			return initials.upcase[0..limit-1]
		else
			return initials.upcase
		end
	end

	# remove_text:
	# 	removes all characters from strings. only leave numbers.
	def remove_text(string)
		return string.gsub(/\D/, '')
	end

	# remove_numbers:
	# 	removes all numbers from strings. only leave other characters.
	def remove_numbers(string)
		return string.gsub(/\d/, '')
	end

  def admin_open_div(size, options = {})
    "<div id=\"#{options[:id]}\" class=\"admin-div-top #{options[:class]}\" style=\"width: #{size}px; #{options[:style]}\"><span class=\"admin-div-top-left\"></span><span class=\"admin-div-top-middle\" style=\"width: #{size - 30}px\"></span><span class=\"admin-div-top-right\"></span></div>
    <div class=\"admin-div-content\" style=\"width: #{size-30}px\">"
  end

  def admin_close_div(size)
    "</div>
    <div class=\"admin-div-bottom\" style=\"width: #{size}px\"><span class=\"admin-div-bottom-left\"></span><span class=\"admin-div-bottom-middle\" style=\"width: #{size-30}px\"></span><span class=\"admin-div-bottom-right\"></span></div>"
  end
  def show_admin_info_for(member, parent)
    return image_tag("admin/admin-div-element-sysadmin.png", 
                      :alt => "sysadmin", 
                      :id => "organization-#{parent.id}-member-#{member.id}-admin", 
                      :class => "admin-div-element-actions-edit-admin") if member.admin?

    action = member.admins?(parent) ? "remove" : "make"
    image = image_tag("admin/admin-div-element-#{action}-admin.png", 
            :alt => "Toggle admin", 
            :title => "Toggle admin", 
            :id => "organization-#{parent.id}-member-#{member.id}-admin", 
            :class => "admin-div-element-actions-edit-admin")

    if(current_member.admins?(parent))
      link_to_remote image,
            :url => { 
              :controller => 'admin/organizations', 
              :action => 'toggle_admin', 
              :id => parent, 
              :member => member },
            :success => "adminToggleImage('organization-#{parent.id}-member-#{member.id}-admin')"
    else
      image
    end 
  end

end
