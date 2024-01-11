# frozen_string_literal: true

module CachedModel
  def cached_all(force = false)
    return all unless MoocApi.settings.cache_ttl.to_i > 0
    stamp = Time.now
    holder = force ? nil : Cacher.get(self.to_s)
    if force || holder.nil?
      holder_new = {
        stamp: stamp,
        data: all
      }
      Cacher.set(self.to_s, holder_new)
      return holder_new[:data]
    end

    if holder[:stamp] < stamp - MoocApi.settings.cache_ttl.to_i
      Resque.enqueue(CacheJob, self.to_s)
    end

    holder[:data]
  end

  def reset_cache
    Cacher.set(self.to_s, nil)
    Resque.enqueue(CacheJob, self.to_s)
  end

end
