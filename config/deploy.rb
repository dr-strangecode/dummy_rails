require 'bundler/capistrano'


set :application, "dummy_rails"
set :repository,  "git@github.com:dr-strangecode/dummy_rails.git"
set :deploy_to,   "/opt/numerex/rails_test/"

set :scm, :git
set :scm_verbose, true
set :keep_releases, "4"
set :use_sudo, false
set :deploy_via, :copy
set :copy_cache, false
#set :copy_exclude, ['.git']
set :user, 'numerex'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Create symlinks for shared image upload directories"
  task :create_symlinks do
    run "ln -fs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  after 'deploy:update_code', 'deploy:create_symlinks'
end

task :staging do
  set :rails_env, 'staging'
  set :branch, 'staging'
  role :web, "app.changeme.com"
  role :app, "app.changeme.com"
  role :db,  "app.changeme.com", :primary => true
end

task :production do
  set :rails_env, 'production'
  set :branch, 'production'
  role :web, "app.changeme.com"
  role :app, "app.changeme.com"
  role :db,  "app.changeme.com", :primary => true
end

