# Load DSL and set up stages
require 'capistrano/setup'
# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/scm/git'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rake'
require 'capistrano/puma'
require 'capistrano/linked_files'
require 'capistrano/passenger'
require 'capistrano/puma/monit'
require 'capistrano/rbenv'

install_plugin Capistrano::Puma
install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma::Monit

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
