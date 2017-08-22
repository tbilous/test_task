# config valid only for current version of Capistrano
lock "3.9.0"

set :application, 'tapp'
set :repo_url, 'git@github.com:tbilous/test_task.git'

set :puma_user, fetch(:user)

set :rbenv_type, :user # or :system, depends on your rbenv setup
# in case you want to set ruby version from the file:
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
# set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
set :rbenv_map_bins, %w{rake gem bundle ruby rails puma pumactl sidekiqctl sidekiq}

# set :yarn_target_path, -> { release_path.join('subdir') } # default not set
# Default branch is :master
# f481bc67e21339f441de5afb071248ace0f706ce
# Default deploy_to directory is /var/www/my_app_name


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'tmp/logs'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2
