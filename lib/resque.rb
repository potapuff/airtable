require 'resque'

resque_config = YAML::load(ERB.new(IO.read('config/resque.yml')).result)
Resque.redis = resque_config[Sinatra::Application.settings.environment]
Resque.redis.namespace = "MoocApi"
