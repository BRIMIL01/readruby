module ReadRuby
  
  require 'pp'

  class Example
     EXAMPLE_REX = /^\s{4}\s*.+ #\s*=>/

    def self.example?(line)
      !!line.match(EXAMPLE_REX)
    end

    attr_reader :example

    def initialize(example)
      @example = example
      @given, @expected = @example.split(/\s*#=>\s*/)
    end

    def actual
      pretty_eval(self.given)
    end

    def expected
      pretty_eval(@expected)
    end

    def given
      @given.strip
    end

    def ok?
      self.expected == self.actual
    end

    def to_s
      (' ' * 4) + example.lstrip
    end

    def error
      InvalidExampleError.new self
    end

    private
    def pretty_eval(string)
      eval(string).pretty_inspect.strip.chomp
    end
  end
  
  class InvalidExampleError < Exception
    def initialize(example)
      super "<<#{example.example}>>: got #{example.actual}; expected #{example.expected}"
    end
  end
end
