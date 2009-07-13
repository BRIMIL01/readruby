module ReadRuby
  
  require 'pp'

  class Example
     EXAMPLE_REX = /^\s{4}\s*.+ #\s*=>/

    def self.example?(line)
      !!line.match(EXAMPLE_REX)
    end

    def initialize(example)
      @given, @expected = example.split(/\s*#=>\s*/)
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

    private
    def pretty_eval(string)
      eval(string).pretty_inspect.strip.chomp
    end
  end
end
