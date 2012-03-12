###############################
#
# Capistrano Deployment on shared Webhosting by RailsHoster
#
# maintained by support@railshoster.de
#
###############################

# BITTE ENTFERNEN SIE DIE FOLGENDE ZEILE WENN SIE BUNDLER NICHT BENUTZEN
require 'bundler/capistrano'


#### Personal Settings
## User and Password

# user to login to the target server
set :user, "user87391798"


# allow SSH-Key-Forwarding
set :ssh_options, { :forward_agent => true }  
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

## Application name and repository

# application name ( should be rails1 rails2 rails3 ... )
set :application, "rails1"

# repository location
set :repository, "git@github.com:wolfoo2931/redmine.git"

# :subversionn or :git
set :scm, :git
set :scm_verbose, true

#### System Settings
## General Settings ( don't change them please )

# run in pty to allow remote commands via ssh
default_run_options[:pty] = true

# don't use sudo it's not necessary
set :use_sudo, false

# set the location where to deploy the new project

set :deploy_to, "/home/user87391798/rails1"

# live
role :app, "ny.railshoster.de"
role :web, "ny.railshoster.de"
role :db,  "ny.railshoster.de", :primary => true

# railshoster bundler settings
set :bundle_flags, "--deployment --binstubs"

############################################
# Default Tasks by RailsHoster.de
############################################
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Additional Symlinks ( database.yml, etc. )"
  task :additional_symlink, :roles => :app do
    run "ln -sf #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  end
end

namespace :railshoster do
  desc "Show the url of your app."
  task :appurl do
    puts "\nThe default RailsHoster.com URL of your app is:"
    puts "\nhttp://user87391798-1.ny.railshoster.de"    
    puts "\n"
  end
end

after "deploy:symlink","deploy:additional_symlink","deploy:migrate"
