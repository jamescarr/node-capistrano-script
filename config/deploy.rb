set :stages, %w[staging production]       # include however many stages you want here
set :default_stage, 'staging'             
require 'capistrano/ext/multistage'

set :application, "your-application-name"
set :node_file, "app.js"                  # this is the entry point to your app that should run as a deamon
set :host, "localhost"                    # host your app will deploy to. List represents multiple hosts
set :repository, "git@github.com:jamescarr/sample-node-app.git"  # duh
set :user, "node"                               # user to ssh in as
set :admin_runner, 'node'                       # user to run the application node_file as
set :application_binary, '/usr/local/bin/node'  # application for running your app. Use coffee for coffeescript apps

set :scm, :git
set :deploy_via, :remote_cache
role :app, host
set :use_sudo, true
default_run_options[:pty] = true

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "sudo start #{application}_#{node_env}"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "sudo stop #{application}_#{node_env}"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo restart #{application}_#{node_env} || sudo start #{application}_#{node_env}"
  end

  desc "Check required packages and install if packages are not installed"
  task :update_packages, roles => :app do
    run "cd #{release_path}/twilio && npm install"
  end

  task :create_deploy_to_with_sudo, :roles => :app do
    run "sudo mkdir -p #{deploy_to}"
    run "sudo chown #{admin_runner}:#{admin_runner} #{deploy_to}"
  end
  
  desc "writes the upstart script for running the daemon. Customice to your needs"
  task :write_upstart_script, :roles => :app do
    upstart_script = <<-UPSTART
  description "#{application}"

  start on startup
  stop on shutdown

  script
      # We found $HOME is needed. Without it, we ran into problems
      export HOME="/home/#{admin_runner}"
      export NODE_ENV="#{node_env}"
      cd #{current_path}

      exec sudo -u #{admin_runner} sh -c "NODE_ENV=#{node_env} #{application_binary} #{current_path}/twilio/#{node_file} #{application_port} >> #{shared_path}/log/#{node_env}.log 2>&1"
  end script
  respawn
UPSTART
  put upstart_script, "/tmp/#{application}_upstart.conf"
    run "sudo mv /tmp/#{application}_upstart.conf /etc/init/#{application}_#{node_env}.conf"
  end

  desc "Update submodules"
  task :update_submodules, :roles => :app do
    run "cd #{release_path}; git submodule init && git submodule update"
  end

  desc "create deployment directory"
  task :create_deploy_to_with_sudo, :roles => :app do
    run "sudo mkdir -p #{deploy_to}"
    run "sudo chown #{admin_runner}:#{admin_runner} #{deploy_to}"
  end

end


before 'deploy:setup', 'deploy:create_deploy_to_with_sudo'
after 'deploy:setup', 'deploy:write_upstart_script'
after "deploy:finalize_update", "deploy:update_submodules", "deploy:update_packages", 

