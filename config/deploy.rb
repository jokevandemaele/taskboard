set :application, "taskboard"
set :repository,  "http://dev.agilar.org/svn/taskboard/"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/rails/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

set :use_sudo, false

server "dev.agilar.org", :app, :web, :db, :primary => true

set :user, "nictuku"

namespace :deploy do
   desc "Restarting mod_rails with restart.txt"
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{current_path}/tmp/restart.txt"
   end

  desc "Change owner group for created directories"
  task :update_owner_group do
    sudo "chown -R apache: #{deploy_to}"
  end

  task :create_db_symlink do
    sudo "ln -s #{deploy_to}/shared/db/production.sqlite3 #{deploy_to}/current/db/"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  after "deploy:setup", "deploy:update_owner_group"
  after "deploy:start", "deploy:create_db_symlink"
end

