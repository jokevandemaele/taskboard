set :application, "taskboard"
set :repository,  "http://dev.agilar.org/svn/taskboard/"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/rails/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "dev.agilar.org"
role :web, "dev.agilar.org"
role :db,  "dev.agilar.org", :primary => true