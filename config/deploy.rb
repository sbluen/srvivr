# The tutoirals
# Short: http://craiccomputing.blogspot.com/2009/07/rails-git-capistrano-ec2-and-ssh.html
# "Long": http://riccardotacconi.blogspot.com/2010/01/rails-deployment-with-capistrano-and.html
# http://net.tutsplus.com/tutorials/ruby/setting-up-a-rails-server-and-deploying-with-capistrano-on-fedora-from-scratch/

set :application, "srvivr"

# The directory on the EC2 Node that will be deployed to
set :deploy_to,  "/mnt/#{application}"

# Version control type
set :scm, :subversion

# The location of the local repository relative to the current app
set :repository, "http://wush.net/svn/cs290/srvivr"

# The address of the remote host on EC2 (the Public DNS address)
set :location, "ec2-107-22-97-230.compute-1.amazonaws.com" 

# The different roles: Can be changed as soon as we start using multiple of servers...
role :web,        location                              
role :app,        location                              
role :db,         location, :primary => true              # This is where Rails migrations will run
role :tileserver, location
role :fetcher,    location

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  
  desc "Restart the application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  desc "Install required gems"
  task :gems, roles: :app do
    run "cd #{current_path} " +
       # "&& bundle config build.linecache19 --with-openssl=/usr/bin/openssl --with-openssl-lib=/usr/lib/openssl " +
        "&& bundle install"
  end
  before "deploy:restart", "deploy:gems"
  
  desc "Migrating Database"
  task :migrate, roles: :app do
    run "cd #{current_path} && bundle exec rake db:migrate"
  end
  before "deploy:restart", "deploy:migrate"
  
  desc "Change owner to ngnix"
  task :chowner, roles: :app do
    run "cd #{current_path}/.. && chown -R nginx:nginx *"
  end
  after "deploy", "deploy:chowner"
  
  before "deploy", "deploy:web:disable"
  after "deploy", "deploy:web:enable" 
end

namespace :setup do 
  desc "Setup ut the application for the first time"
  task :default do
    db
    db:seed
    install_ant
    fix_ruby_install
  end
  
  namespace :db do
    desc "Sets up databsase"
    task :default, roles: :db do
      run "rake db:setup"
    end
    
    desc "Add seed data to the database"  
    task :seed, roles: :db do
      run "cd #{current_path} && bundle exec rake db:seed"
    end
  end
  
  desc "Install ant"
  task :install_ant, roles: [:tileserver, :fetcher] do
    run "yum install ant --skip-broken"
  end
  
  desc "Fix Ruby Install"
  task :fix_ruby_install, roles: :app do
    run "cd /root/ruby-1.9.2-p0/ext/openssl " + 
        "&& ruby extconf.rb --with-openssl=/usr/bin/openssl --with-openssl-lib=/usr/lib/openssl " +
        "&& make " +
        "&& make install"
  end
  
  after "setup", "deploy"
end

desc "Run the different tileservers"
namespace :runners do
  task :default do 
    setup
    tiles:start
    fetcher:start
  end
  
  task :setup, roles: [:tileserver, :fetcher] do
    # this has to be redone when fetcher and/or tileserver
    # are being moved for performance gain
    run "cd #{current_path}/backend && ant build"
  end
  
  namespace :tiles do
    desc "Starts the tileserver"
    task :start, roles: :tileserver do
       run "cd #{current_path}/backend && ant TileServer &" 
    end
  end
  
  namespace :fetcher do
    desc "Starts the fetcher"
    task :start, roles: :fetcher do
      run "cd #{current_path}/backend && ant Fetcher &"
    end
  end
end

# Default account on EC2 is root. Should probably change that..
set :user, "root"

# Set up SSH so it can connect to the EC2 node, assumes that everyone has downloaded
# the SSH key (from RightScale) and added it to ~/.ssh
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")] 

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end