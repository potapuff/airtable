require 'rake'
require 'resque'
require 'resque/tasks'

Bundler.require
require 'newrelic_rpm'
require './app'

Resque.logger.level = Logger::DEBUG

task 'environment' do end

task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { AlbumsApi::DATABASE.disconnect }
end
