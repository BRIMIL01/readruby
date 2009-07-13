module ReadRuby
  class Invocation
    
    attr_accessor :object, :method, :text

    def initialize(object, method, text)
      @object, @method, @text = object, method, text.dup
      raise ArgumentError unless @object.is_a?(Class)
      raise ArgumentError unless @method.is_a?(Symbol)
      raise ArgumentError unless @text.is_a?(String)
      raise NoMethodError, "#{object}##{method}" unless valid_method?
      preprocess
    end

    def preprocess
      text.gsub!(/@method/, method.to_s)
      text.gsub!(/@object/, object.to_s)
    end

    def parse
      @parsed ||= text.split("\n").map do |line|
          if Signature.signature? line
            Signature.new line
          elsif Example.example? line
            Example.new line
          else
            line
        end
      end
    end

    def validate
      parse.each do |line|
        if line.respond_to?(:ok?)
          line.ok? or raise SyntaxError, line
        end
      end
      unless parse.one? {|l| l.is_a? Signature }
        raise SyntaxError, "Description does not have exactly one signature"
      end
    end

    def description
      lines_of(String)
    end

    def signature
      lines_of(Signature).first
    end

    def examples
      lines_of(Example)
    end

    def to_s
      s = "    #{object}##{method}#{signature.to_s}\n"
      s << description.join unless description.empty?
      s << examples.map{|e| "    #{e.to_s}"}.join unless examples.empty?
      s
    end

    private
    def valid_method?
      self.object.method_defined?(self.method) ||
      # We use this ugly construct so as to be compatiable with both 1.8,
      # where .singleton_methods returned Strings, and 1.9, where it returns
      # Symbols 
      self.object.singleton_methods.any? {|m| m.to_sym == self.method }
    end

    def lines_of(klass)
      self.parse.select {|line| line.is_a? klass }
    end
  end
end
