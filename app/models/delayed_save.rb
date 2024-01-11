# frozen_string_literal: true
require 'fileutils'
require 'resque'
require 'google_drive'

module DelayedSave

  PREFIX_INPUTS = 'queue_in/'
  PREFIX_RESULTS = 'queue_out/'
  MAX_LENGTH = 1024

  def append!(params)
    result = self::KEYS.map do |key|
      v = params[key]
      v = v.keys if v.respond_to?(:keys)
      v = v.join('; ') if v.is_a?(Array)
      v = v.sanitize
      throw "Bad value" if value.size > MAX_LENGTH
      v
    end
    throw "Bad value" if result.all?{|value|  value.empty?}

    FileUtils.mkdir_p(PREFIX_INPUTS)
    File.open(PREFIX_INPUTS+Time.now.to_i.to_s, 'w'){|f| f.write MultiJson.dump({class: self.to_s, playload: result})}
    Resque.enqueue(PersisterJob)
  end

end
