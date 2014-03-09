require 'bundler/capistrano'

default_run_options[:pty] = true
set :default_environment, {
  "PATH" => "/opt/rbenv/shims:/opt/rbenv/bin:$PATH"
}
set :ssh_options, { :forward_agent => true }

set :application, "my_stats"
set :repository, "git@github.com:adtaylor/my_stats.git"
set :user, "ubuntu"
set :use_sudo, true

server "54.72.46.216", :web, :app, :db, :primary => true

after "deploy:finalize_update", "symlink:all"

namespace :symlink do
  task :env do
    run "ln -nfs #{shared_path}/config/.env #{release_path}/.env"
  end
  task :db do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  task :all do
    symlink.db
    symlink.env
  end
end

namespace :deploy do

  task :start do
    run "#{current_path}/bin/unicorn -Dc #{shared_path}/config/unicorn.rb -E #{rails_env} #{current_path}/config.ru"
  end

  task :restart do
    run "kill -USR2 $(cat #{shared_path}/pids/unicorn.pid)"
  end

end

after "deploy:restart", "deploy:cleanup"

namespace :dotenv do
  
  desc "Upload local .env file to server"
  task :upload do 
    top.upload File.expand_path('../../.env', __FILE__) , "#{shared_path}/config/.env"
  end

end
