namespace :deploy do
    set :application, "taskboard"

    # If you aren't deploying to /u/apps/#{application} on the target
    # servers (which is the default), you can specify the actual location
    # via the :deploy_to variable:
    set :deploy_to, "/var/www/rails/#{application}/testing"

    # If you aren't using Subversion to manage your source code, specify
    # your SCM below:
    set :scm, :git
    set :repository,  "http://github.com/agilar/taskboard.git"
    set :branch, "authlogic_migration"

    set :use_sudo, false
    
    begin 
      revision = `/usr/bin/curl -s -u deploy:agilar.deploy.99 http://hudson.dev.agilar.org:8080/job/agora-0-continuous-integration/lastSuccessfulBuild/api/xml`
      revision.match(/<lastBuiltRevision><SHA1>[a-z0-9]*<\/SHA1>/)
      revision = $~.to_s.gsub("<lastBuiltRevision><SHA1>",'').gsub("</SHA1>", '')
      set :revision, revision
    rescue
      raise "ProblemAccessingHudson"
    end
    
    server "dev.agilar.org", :app, :web, :db, :primary => true

    set :user, "deploy"


   desc "Restarting mod_rails with restart.txt"
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{current_path}/tmp/restart.txt"
   end

  task :create_member_pictures_symlink do
   run "ln -s #{deploy_to}/shared/images/members #{deploy_to}/current/public/images/"
  end

  task :rake_db_migrate do
    run "cd #{current_path}/ && rake RAILS_ENV=\"testing\" db:migrate"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  after "deploy:update", "deploy:rake_db_migrate", "deploy:create_member_pictures_symlink"
end