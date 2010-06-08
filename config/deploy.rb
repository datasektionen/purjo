set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

default_environment["PATH"] = "/opt/ruby-enterprise/current/bin/:$PATH"

set :application, "purjo"
set :repository, "file:///var/svn/ior/purjo/trunk"
set :local_repository, "https://www.d.kth.se/svn/ior/purjo/trunk"
set :deploy_to, "/var/rails/#{application}" # Will be updated for each stage with stage specific path.
set :user, "capistrano"
set :use_sudo, false
set :rails_env, "migration"
set :tmp_path, "/var/tmp/rails"
set :keep_releases, 3

role :app, "haagen-dazs.stacken.kth.se"
role :web, "haagen-dazs.stacken.kth.se"
role :db,  "haagen-dazs.stacken.kth.se", :primary => true

namespace :deploy do
  desc "Authenticate using Kerberos"
  task :kauth do
    run("kauth -t /home/capistrano/krb5.keytab.capistrano capistrano/haagen-dazs.stacken.kth.se")
  end

  desc "Flush authetication tokens"
  task :kdestroy do
    run("kdestroy")
  end

  desc "Copy the config files"
  task :update_config do
    run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
    run "ln -sf #{release_path}/config/environments/development.rb #{release_path}/config/environments/migration.rb"
  end

  desc "Symlink public/file_nodes"
  task :symlink_file_nodes do
    run "ln -sf #{shared_path}/public/file_nodes #{release_path}/public/file_nodes"
  end

  desc "Symlink public/system"
  task :symlink_system do
    run "ln -sf #{shared_path}/public/system #{release_path}/public/system"
  end

  desc "Symlink tmp"
  task :symlink_tmp do
    run "rm -rf #{release_path}/tmp"
    run "ln -sf #{tmp_path}/#{application}/#{stage} #{release_path}/tmp"
  end

  desc "Set permissions for public/{stylesheets,javascripts}"
  task :set_permissions do
    run "setfacl -m u:www-data:rwx #{release_path}/public/{stylesheets,javascripts}"
    run "setfacl -d -m u:www-data:rwx #{release_path}/public/{stylesheets,javascripts}"
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  before "deploy:update_code", "deploy:kauth"
  after  "deploy:update_code", "deploy:kdestroy"
  after  "deploy:update_code", "deploy:update_config"
  after  "deploy:update_code", "deploy:symlink_file_nodes"
  after  "deploy:update_code", "deploy:symlink_system"
  after  "deploy:update_code", "deploy:symlink_tmp"
  after  "deploy:update_code", "deploy:set_permissions"
  after  "deploy:update", "deploy:cleanup"
end
