<% remote_form_for @organization, :update => "dummy-for-actions" do |f| %>
  <%= f.error_messages %>

  <p>
    <%= f.label :name %><br />
    <%= f.text_field :name -%><br />
    <% if !@projects.empty? -%>
      <%= f.label :projects %><br />
      <div id="selected-projects">
      </div>
      <%= select_tag "projects", options_from_collection_for_select(@projects, 'id', 'name') -%>
      <%= button_to_remote "Add", :url => { :action => :add_project } %>
    <% end -%>
  </p>
  <p>
    <%= f.submit "Create" %>
  </p>
<% end %>
