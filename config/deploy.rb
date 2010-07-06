set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

default_environment["PATH"] = "/opt/ruby-enterprise/current/bin/:$PATH"

set :application, "purjo"
set :scm, :git
set :deploy_via, :remote_cache

ssh_options[:forward_agent] = true

set :repository, "git@turtle-soup.ben-and-jerrys.stacken.kth.se:purjo.git"
set :deploy_to, "/var/rails/#{application}" # Will be updated for each stage with stage specific path.
set :user, "capistrano"
set :use_sudo, false

set :rails_env, "migration"
set :tmp_path, "/var/tmp/rails"
set :keep_releases, 3

role :app, "mission-to-marzipan.ben-and-jerrys.stacken.kth.se"
role :web, "mission-to-marzipan.ben-and-jerrys.stacken.kth.se"
role :db,  "mission-to-marzipan.ben-and-jerrys.stacken.kth.se", :primary => true

namespace :deploy do
  desc "Authenticate using Kerberos"
  task :kauth do
    run("kauth -t /home/capistrano/krb5.keytab.capistrano capistrano/haagen-dazs.stacken.kth.se")
  end
  #before "deploy:update_code", "deploy:kauth"
  

  desc "Flush authetication tokens"
  task :kdestroy do
    run("kdestroy")
  end
  #after  "deploy:update_code", "deploy:kdestroy"
  
  desc "Copy the config files"
  task :update_config do
    run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
    run "ln -sf #{release_path}/config/environments/development.rb #{release_path}/config/environments/migration.rb"
  end
  after  "deploy:update_code", "deploy:update_config"
  
  desc "Symlink public/file_nodes"
  task :symlink_file_nodes do
    run "ln -sf #{shared_path}/public/file_nodes #{release_path}/public/file_nodes"
  end
  after  "deploy:update_code", "deploy:symlink_file_nodes"
  
  desc "Symlink public/system"
  task :symlink_system do
    run "ln -sf #{shared_path}/public/system #{release_path}/public/system"
  end
  after  "deploy:update_code", "deploy:symlink_system"

  desc "Symlink tmp"
  task :symlink_tmp do
    app_tmp = "#{tmp_path}/#{application}/#{stage}"
    run "mkdir -p #{app_tmp}"
    run "rm -rf #{release_path}/tmp"
    run "ln -sf #{app_tmp} #{release_path}/tmp"
  end
  after  "deploy:update_code", "deploy:symlink_tmp"

  desc "Set permissions for public/{stylesheets,javascripts}"
  task :set_permissions do
    #run "setfacl -m u:www-data:rwx #{release_path}/public/javascripts"
    #run "setfacl -m u:www-data:rwx #{release_path}/public/stylesheets"
    #run "setfacl -d -m u:www-data:rwx #{release_path}/public/{stylesheets,javascripts}"
  end
  after  "deploy:update_code", "deploy:set_permissions"
  
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  after  "deploy:update", "deploy:cleanup"
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test --without development"
  end
  after 'deploy:update_code', 'bundler:bundle_new_release'
end
 
