# frozen_string_literal: true

require 'resque'
require 'google_drive'

class CacheJob
  @queue = :cache

  def self.perform(klass)
    stamp = Time.now
    holder = Cacher.get(klass)
    if (holder && holder[:stamp] > stamp - ttl)
      return
    end

    klass = klass[0] if klass.is_a? Array
    klass = Object.const_get(klass)
    klass.cached_all(true)
  rescue StandardError => error
    Rollbar.error(error)
  end

private

  def ttl
    resque_config = YAML::load(ERB.new(IO.read('config/production.yml')).result)
    value = resque_config['cache_ttl'].to_i
    throw "Wrong value for 'cache_ttl' at config/production.yml" if value == 0

    return value
  end

end
