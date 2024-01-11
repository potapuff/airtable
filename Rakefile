require 'rake'

  Bundler.require
require './app'

Resque.logger.level = Logger::ERROR

task 'environment' do end

#Resque
require './lib/resque'
require 'resque'
require 'resque/tasks'

