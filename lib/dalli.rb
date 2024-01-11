require 'dalli'

class Cacher

  def self.get(key)
    puts "CACHE[#{key}]"
    init.get(key)
  end

  def self.set(key,value)
    puts "CACHE[#{key}]=..."
    init.set(key, value)
  end

  def self.client
    init
  end

private

  def self.init
   @@cacher ||= Dalli::Client.new('localhost:11211', { namespace: "MoocApi" })
  end
end

