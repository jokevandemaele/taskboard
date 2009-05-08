<script>
$('adder-container').show();
</script>
<div id="form-add-organization" class="dynamic-form" style="display: none;">

<% remote_form_for @organization, :update => "dummy-for-actions" do |f| %>
  <%= f.error_messages %>

  <p>
    <%= f.label :name %><br />
    <%= f.text_field :name -%><br />
  </p>
  <p>
    <%= f.submit "Create" %>
    <%= button_to_function "Cancel", "cancel($('form-add-organization'));", :id => "form-add-organization-cancel"-%>
    
  </p>
<% end %>
<script>
	centerTo($('form-add-organization'),$('adder-container'));
	Effect.Appear($('form-add-organization'));
</script>
</div>
