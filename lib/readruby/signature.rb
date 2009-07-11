module ReadRuby
  class Signature
    # Matches a class name, e.g. String or NilClass
    CLASS_PAT = '([A-Z]\w+)(?:\W+|$)'
    # Matches the method signature. We are intentionally vague about the
    # return type declaration because it's more readable to use #scan on the
    # captured portion than delegate both tasks to the regex
    SIGNATURE_REX = /^\s{4}.+ => \s*(#{CLASS_PAT}.*)$/o

    attr_accessor :object, :method, :description

    def initialize(object, method, description)
      @object = object
      raise ArgumentError unless @object.is_a?(Class)
      @method = method
      raise ArgumentError unless @method.is_a?(Symbol)
      @description = description
      raise ArgumentError unless @description.is_a?(String)
      raise NoMethodError, "#{object}##{method}" unless valid_method?
    end

    def returns
      match = self.description.split(/\n/)[0][SIGNATURE_REX, 1] or return []
      match.scan(/#{CLASS_PAT}/).map do |type|
        type = type.first
        begin
          Object.const_get(type.to_sym)
        rescue NameError
          raise NameError, "Invalid return type: #{type.to_sym}"
        end
      end
    end

    private
    def valid_method?
      self.object.method_defined?(self.method) ||
      # We use this ugly construct so as to be compatiable with both 1.8,
      # where .singleton_methods returned Strings, and 1.9, where it returns
      # Symbols 
      self.object.singleton_methods.any? {|m| m.to_sym == self.method }
    end
  end
end
