module SearchQueryParser
  class Grammar
    def self.prepare_text(text)
      text.
        gsub(/[&]+/, '&').
        gsub(/[|]+/, '|').
        gsub(/[^[:alnum:]\-()&|!]+/, ' ').
        gsub(/([^[:alnum:]]|^)\-/, '\1').
        gsub(/\-([^[:alnum:]]|$)/, '\1').
        gsub(/ ?([|&]) ?/, '\1').
        gsub(/(!) /, '\1').
        gsub(/(\() /, '\1').
        gsub(/ (\))/, '\1').
        strip
    end

    attr_reader :expression

    def initialize(e)
      if e.is_a?(String)
        @expression = [:term, e]
      elsif e.is_a?(Array)
        @expression = e
      else
        raise RuntimeError.new("Unknown expression #{e.inspect} of #{e.class.name}")
      end
    end

    def join(other)
      self.class.new([:join, self, other])
    end
    def >>(other)
      join(other)
    end

    def and(other)
      self.class.new([:and, self, other])
    end
    def &(other)
      self.and(other)
    end

    def or(other)
      self.class.new([:or, self, other])
    end
    def |(other)
      self.or(other)
    end

    def not
      self.class.new([:not, self])
    end
    def !
      self.not
    end

    # Block to reduce must be given and accept
    # (op, x, y), (term, x), (not, x)
    # and return the result of applying op to (x, y) or x (for 'term' and 'not')
    def reduce(&block)
      op, x, y = @expression
      case op
      when :term
        yield(:term, x, nil)
      when :not
        yield(:not, x.reduce(&block), nil)
      when :and
        yield(:and, x.reduce(&block), y.reduce(&block))
      when :or
        yield(:or, x.reduce(&block), y.reduce(&block))
      when :join
        yield(:join, x.reduce(&block), y.reduce(&block))
      else
        raise RuntimeError.new("Unknown op #{op.inspect}")
      end
    end

    def to_s
      reduce do |op, x, y|
        case op
        when :term
          x
        when :and
          "(#{x} & #{y})"
        when :or
          "(#{x} | #{y})"
        when :join
          "(#{x} <-> #{y})"
        when :not
          "(! #{x})"
        end
      end
    end
  end
end
