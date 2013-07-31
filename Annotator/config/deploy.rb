require 'bundler/capistrano'

set :rake, "#{rake} --trace"

set :application, "tweet_app"


set :scm, :git
set :repository, "git@github.com:DublinSam/Annotator.git"

set :deploy_via, :remote_cache

set :scm_user, "DublinSam"
set :scm_password, "FatherMatthews1"

set :keep_releases, 5
after "deploy:restart", "deploy:cleanup"

#ssh_options[:forward_agent] = true
ssh_options[:keys] = ["/Users/Sam/.ssh/Annotator.pem"]
set :ssh_key, "/Users/Sam/.ssh/Annotator.pem"

ssh_options[:keys_only] = true
set :use_sudo, true

set :application, "tweet_app"
set :user, "ubuntu"

default_run_options[:pty] = true

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

server "ec2-184-73-133-73.compute-1.amazonaws.com", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
set :branch, "master"

after 'deploy:update_code', 'deploy:migrate'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

 #If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do
     puts RUBY_VERSION
   end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
