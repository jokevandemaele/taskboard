# This initializer is used to disable mass asignment by default.
# You should allow the users to write specific parameters using attr_accessible
# MORE INFO: http://railspikes.com/2008/9/22/is-your-rails-application-safe-from-mass-assignment
ActiveRecord::Base.send(:attr_accessible, nil)
