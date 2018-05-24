require 'mina/bundler'
require 'mina/rails'
require 'mina/rvm'
require 'mina/git'
require 'mina/puma'
require 'mina_sidekiq/tasks'

# Set the domain and port of the remote server.
set :domain, '206.189.59.240'
set :port, 7871
set :forward_agent, true


# Set the folder of the remote server where Mina will deploy your application.
set :deploy_to, '/srv/the-death-star'

# Set a link to the repository. Example: git@bitbucket.pixelpoint/myapp.git
set :repository, 'git@github.com:BabenkoOleg/the-death-star.git'

# Set the name of a branch you plan to deploy as default master.
set :branch, 'master'

# Fill in the names of the files and directories that will be symlinks to the shared directory.
# All folders will be created automatically on Mina setup.
# Don't forget to add a path to the uploads folder if you are using Dragonfly or CarrierWave.
# Otherwise, you will lose your uploads on each deploy.
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'public/uploads')
set :shared_files, fetch(:shared_files, []).push('config/application.yml', 'config/database.yml', 'config/secrets.yml', 'config/puma.rb')

# Username of ssh user for access to the remote server.
set :user, 'darth_vader'

# This is not a required field. You can use it to set an application name for easy recognition.
set :application_name, 'TheDeathStar'

# Set ruby version. If you have RVM installed globally, you'll also need to set an RVM path,
# like: set :rvm_use_path, '/usr/local/rvm/scripts/rvm'.
# You can find the RVM location with the rvm info command.
task :remote_environment do
  invoke :'rvm:use', 'ruby-2.6.0-preview1'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  command %(mkdir -p "#{fetch(:deploy_to)}/shared/tmp/sockets")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/sockets")

  command %(mkdir -p "#{fetch(:deploy_to)}/shared/tmp/pids")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/pids")

  command %(mkdir -p "#{fetch(:deploy_to)}/shared/pids/")
  command %(mkdir -p "#{fetch(:deploy_to)}/shared/log/")
  command %(mkdir -p "#{fetch(:deploy_to)}/shared/public/uploads/")

  command %(touch "#{fetch(:deploy_to)}/shared/config/database.yml")
  command %(touch "#{fetch(:deploy_to)}/shared/config/secrets.yml")
end

desc 'Deploys the current version to the server.'
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'sidekiq:quiet'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        invoke :remote_environment
        invoke :'puma:phased_restart'
        invoke :'sidekiq:restart'
      end
    end
  end
end
