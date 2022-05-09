class String
  def sanitize
    self.gsub(/<\/?[^>]*>/, "")
  end
end

class NilClass
  def sanitize
    self
  end

  def empty?
    true
  end
end

module Sinatra
  module TextHelpers

    def h(text)
      text.to_s.sanitize
    end

  end

  module LayoutHelpers
    def extra_head *args
      @extra_head ||= []
      @extra_head += Array(args) unless args.empty?
      @extra_head
    end

    def f(file)
      @@__file__cache ||= {}
      unless @@__file__cache[file]
        @@__file__cache[file] = File.ctime('public/'+file).to_i.to_s
      end
      file+'?v='+@@__file__cache[file]
    end

  end

  helpers TextHelpers
  helpers LayoutHelpers
end