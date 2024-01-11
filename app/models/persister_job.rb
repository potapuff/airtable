# frozen_string_literal: true

require 'rollbar'
require 'resque'

class PersisterJob

  @queue = :persist

  def self.perform(*_args)
    files = Dir[DelayedSave::PREFIX_INPUTS+'*'][-3..-1]
    FileUtils.mkdir_p(DelayedSave::PREFIX_RESULTS) unless  files.empty?
    files.each do |file|
      begin
        content = MultiJson.load(IO.read(file))
        klazz = Object.const_get(content['class'])
        result = content['playload']
        worksheet = klazz.auth
        worksheet.insert_rows(worksheet.num_rows + 1, [result])
        worksheet.save
        FileUtils.mv(file, file.sub(DelayedSave::PREFIX_INPUTS, DelayedSave::PREFIX_RESULTS))
      rescue StandardError => e
        Rollbar.error(e)
      end
    end
  end
end
