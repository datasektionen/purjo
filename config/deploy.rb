set :stages, %w(staging production)
#set :default_stage, "staging"
require 'capistrano/ext/multistage'

# Not needed on new server?
#default_environment["PATH"] = "/opt/ruby-enterprise/current/bin/:$PATH"

set :application, "purjo"
set :repository, "git@turtle-soup.ben-and-jerrys.stacken.kth.se:purjo.git"
set :scm, "git"
#set :local_repository, "https://www.d.kth.se/svn/ior/purjo/trunk" # Not needed?
set :deploy_to, "/var/rails/#{application}" # Will be updated for each stage with stage specific path.
set :user, "capistrano"
set :use_sudo, false
set :rails_env, "migration"
set :tmp_path, "/var/tmp/rails"
set :keep_releases, 3

ssh_options[:forward_agent] = true

role :app, "mission-to-marzipan.ben-and-jerrys.stacken.kth.se"
role :web, "mission-to-marzipan.ben-and-jerrys.stacken.kth.se"
role :db,  "mission-to-marzipan.ben-and-jerrys.stacken.kth.se", :primary => true

namespace :deploy do
  #desc "Authenticate using Kerberos"
  #task :kauth do
  #  run("kauth -t /home/capistrano/krb5.keytab.capistrano capistrano/haagen-dazs.stacken.kth.se")
  #end

  #desc "Flush authetication tokens"
  #task :kdestroy do
  #  run("kdestroy")
  #end

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
    #run "setfacl -m user:www-data:rwx #{release_path}/public/{stylesheets,javascripts}"
    #run "setfacl -d -m user:www-data:rwx #{release_path}/public/{stylesheets,javascripts}"
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  #before "deploy:update_code", "deploy:kauth"
  #after  "deploy:update_code", "deploy:kdestroy"
  after  "deploy:update_code", "deploy:update_config"
  after  "deploy:update_code", "deploy:symlink_file_nodes"
  after  "deploy:update_code", "deploy:symlink_system"
  after  "deploy:update_code", "deploy:symlink_tmp"
  after  "deploy:update_code", "deploy:set_permissions"
  after  "deploy:update", "deploy:cleanup"
end

namespace :bundler do
  namespace :bundler do  
    task :create_symlink, :roles => :app do
      set :bundle_dir, 'vendor/bundle'
      
      shared_dir = File.join(shared_path, 'bundle')
      run " cd #{release_path} && rm -rf #{bundle_dir}" # in the event it already exists..?
      run("mkdir -p #{shared_dir} && cd #{release_path} && ln -s #{shared_dir} #{bundle_dir}")
    end
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} ; bundle install #{bundle_dir} --without development --disable-shared-gems"
  end
end
 
after 'deploy:update_code', 'bundler:bundle_new_release'
