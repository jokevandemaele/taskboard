<script>
$('adder-container').show();
</script>
<div id="form-add-organization" style="position: fixed; top: 0px; left: 0px; display: none; z-index: 100; background: white; padding: 10px; border: 5px solid #3771c8;">

<% remote_form_for @organization, :update => "dummy-for-actions" do |f| %>
  <%= f.error_messages %>

  <p>
    <%= f.label :name %><br />
    <%= f.text_field :name -%><br />
  </p>
  <p>
    <%= f.submit "Create" %>
  </p>
<% end %>
<script>
	centerTo($('form-add-organization'),$('adder-container'));
	Effect.Appear($('form-add-organization'));
</script>
</div>
