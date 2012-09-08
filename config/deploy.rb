set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require 'capistrano_colors'

class Capistrano::ServerDefinition
  def to_s
    @to_s ||= begin
      s = @options[:alias] || host
      s = "#{user}@#{s}" if user
      s = "#{s}:#{port}" if port && port != 22
      s
    end
  end
end

set :application, "purjo"
set :repository, "git@github.com:datasektionen/purjo.git"
set :scm, "git"

set :deploy_to, "/var/rails/#{application}" # Will be updated for each stage with stage specific path.
set :user, "rails"
set :use_sudo, false
set :ssh_options, {:forward_agent => true }
set :rails_env, "migration"
set :tmp_path, "/var/tmp/rails"

set(:latest_release) { fetch(:current_path) }
set(:release_path) { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision) { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision) { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }
set(:current_revision_info) { capture("cd #{current_path}; git show -s --oneline").strip }

default_environment["RAILS_ENV"] = 'production'
default_run_options[:shell] = 'bash'

role :app, "clusterfluff.ben-and-jerrys.stacken.kth.se", :alias => "clusterfluff"
role :web, "clusterfluff.ben-and-jerrys.stacken.kth.se", :alias => "clusterfluff"
role :db,  "clusterfluff.ben-and-jerrys.stacken.kth.se", :primary => true, :alias => "clusterfluff"

namespace :deploy do
  desc "Delpoy"
  task :default do
    update
    restart
  end

  desc "Setup a GitHub-style deployment."
  task :setup, :except => {:no_release => true} do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map {|d| File.join(shared_path, d)}
    dir_list = dirs.join(' ')
    run "#{try_sudo} mkdir -p #{dir_list} && #{try_sudo} chmod g+w #{dir_list}"
    run "git clone #{repository} #{current_path}"
  end

  desc "Update the deployed code."
  task :update_code, :except => {:no_release => true} do
    run "cd #{current_path}; git fetch origin; git reset --hard origin/#{branch}"
    finalize_update
  end

  desc "Copy the config files"
  task :update_config do
    run "cd #{shared_path}/config && for file in *; do diff $file #{release_path}/config/$file || cp -Rf $file #{release_path}/config/; done"
    run "ln -sf #{release_path}/config/environments/development.rb #{release_path}/config/environments/migration.rb"
  end

  desc "Run migrations"
  task :migrate, :except => {:no_release => true} do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} /usr/local/bin/ree_bundle exec rake db:migrate"
  end

  desc "Update the database (overridden to avoid symlink)"
  task :migrations do
    transaction do
      update_code
    end
    migrate
    restart
  end

  desc "Symlink stuff"
  task :symlink do
    # nothing to do here, move along
  end

  desc "Restart the app (kill the unicorns)"
  task :restart, :except => { :no_release => true } do
    # we just kill the unicorns, monit will spawn new ones eventually
    run "kill -USR2 `cat #{shared_path}/pids/unicorn.pid` || /bin/true"
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, :except => {:no_release => true} do 
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, :except => {:no_release => true} do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end

  desc "Symlink public/file_nodes"
  task :symlink_file_nodes do
    run "ln -sf #{shared_path}/public/file_nodes #{release_path}/public/file_nodes"
  end

  desc "Symlink public/system"
  task :symlink_system do
    run "ln -sf #{shared_path}/public/system #{release_path}/public/"
  end

  desc "Symlink tmp"
  task :symlink_tmp do
    run "ln -sf #{tmp_path}/#{application}/#{stage} #{release_path}/tmp"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && /usr/local/bin/ree_bundle exec whenever --update-crontab #{application}"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    set :bundle_dir, 'vendor/bundle'
    set :shared_bundle_path, File.join(shared_path, 'bundle')

    run "cd #{release_path} && rm -f #{bundle_dir}" # in the event it already exists..?
    run "mkdir -p #{shared_bundle_path} && cd #{release_path} && ln -s #{shared_bundle_path} #{bundle_dir}"
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path}; /usr/local/bin/ree_bundle install --path #{shared_bundle_path} --without development test"
  end
end

namespace :stats do
  desc "print current git revision"
  task :git_revision, :except => {:no_release => true} do
    puts current_revision_info
  end
end

after 'deploy:update_code', 'bundler:bundle_new_release'
after 'deploy:restart', 'stats:git_revision'
after  "deploy:update_code", "deploy:update_config"
after  "deploy:update_code", "deploy:symlink_file_nodes"
after  "deploy:update_code", "deploy:symlink_system"
after  "deploy:update_code", "deploy:symlink_tmp"
after "deploy:symlink", "deploy:update_crontab"

