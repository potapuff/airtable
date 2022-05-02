class String
  def sanitize
    Sanitize.fragment(self)
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
  end

  helpers TextHelpers
  helpers LayoutHelpers
end