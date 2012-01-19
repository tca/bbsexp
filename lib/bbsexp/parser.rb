module BBSexp
  class Parser
    attr_accessor :exps, :brackets, :end_exp
    attr_reader :regexp, :end_exp

    def initialize
      @exps = {}
      yield self
      @noparse ||= '&'
      exps = [  @brackets[0],
                @exps.keys.join,
                @end_exp,
                @noparse,
                @brackets[1] ].map {|v| Regexp.escape(v) }

      regexp = "%s([%s]+|%s+(%s)?)%s" % exps
      @regexp = Regexp.new(regexp)
    end

    def method_missing(level, sym, args={})
      exp(sym, level, args)
    end

    def exp(sym, state, args={})
      @noparse = sym if state == :noparse
      @exps[sym] = Expression.new(sym, state, args)
    end
    
    def parse(text)
      Instance.new(self, text).build
    end
  end
end