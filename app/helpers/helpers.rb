class String
  def sanitize
    self.gsub(/<\/?[^>]*>/, "")
  end

  def has? str
    index(str) != nil
  end
  
  def filtrate
     value = self.gsub('#N/A','').strip
     value.empty? ? nil : value
  end
  
  def my_split(regexp)
    self.split(regexp)
  end
end

class Array

  # File activesupport/lib/active_support/core_ext/enumerable.rb, line 64
  def index_by
    if block_given?
      result = {}
      each { |elem| result[yield(elem)] = elem }
      result
    else
      to_enum(:index_by) { size if respond_to?(:size) }
    end
  end

  def sanitize
    self.map{|x| x.to_s.sanitize}
  end
end

class NilClass
  def sanitize
    self
  end

  def empty?
    true
  end

  def has? str
    false
  end
  
  def filtrate
    self
  end
  
  def my_split(regexp)
    []
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