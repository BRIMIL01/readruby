module ReadRuby
  class Signature
    # Matches a class name, e.g. String or NilClass
    CLASS_PAT = '([A-Z]\w+)'
    VAR_PAT = '([a-z0-9_]\w+)'
    # Matches the method signature. We are intentionally vague about the
    # return type declaration because it's more readable to use #scan on the
    # captured portion than delegate both tasks to the regex
    SIGNATURE_REX = /^\s{4}\s*\(([^\)]*)\)\s*=> \s*(#{CLASS_PAT}.*)$/o

    attr_accessor :description

    def initialize(description)
      @description = description
      raise ArgumentError unless @description.is_a?(String)
    end

    def signature
      match = self.description.split(/\n/)[0][SIGNATURE_REX, 1] or return [[]]
      sig = match.scan(/#{CLASS_PAT}( #{VAR_PAT})?/o).map do |type, variable|
        begin
          type = Object.const_get(type.to_sym)
        rescue NameError
          raise NameError, "Invalid signature type: #{type.to_sym}"
        end
        variable.nil? ? [type] : [type, variable.strip.to_sym]
      end
      sig.empty? ? [[]] : sig
    end

    def returns
      match = self.description.split(/\n/)[0][SIGNATURE_REX, 2] or return []
      match.scan(/#{CLASS_PAT}/o).map do |type|
        type = type.first
        begin
          Object.const_get(type.to_sym)
        rescue NameError
          raise NameError, "Invalid return type: #{type.to_sym}"
        end
      end
    end

    def signature_str
      self.signature.map do |element|
        element.size == 2 ? element.join(' ') : element.first
      end.join(', ')
    end

    def returns_str
      self.returns.join(' or ')
    end

    def format(object, method)
      raise ArgumentError unless object.is_a?(Class)
      raise ArgumentError unless method.is_a?(Symbol)
      str = "    #{object}##{method}("
      str << self.signature_str
      str << ') => '
      str << self.returns_str
      str
    end

    def description_sans_metadata
      self.description.split(/\n/).reject {|l| l =~ SIGNATURE_REX }.join("\n")
    end
  end
end
