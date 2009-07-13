module ReadRuby
  class Signature
    # Matches a class name, e.g. String or NilClass
    CLASS_PAT = '([A-Z]\w+)'
    SELF_OR_BOOL_PAT = 'self|true|false|nil'
    RETURN_PAT = '((' + CLASS_PAT + ')|' + SELF_OR_BOOL_PAT + ')'
    VAR_PAT = '([a-z0-9_]\w+)'
    BLOCK_PAT = '\{[^\}]+\}'
    # Matches the method signature. We are intentionally vague about the
    # return type declaration because it's more readable to use #scan on the
    # captured portion than delegate both tasks to the regex
    SIGNATURE_REX = /^\s{4}\s*\(([^\)]*)\)\s*(#{BLOCK_PAT})?\s*=> \s*(#{RETURN_PAT}.*)$/o

    def self.signature?(line)
      !!line.match(SIGNATURE_REX)
    end

    attr_accessor :description

    def initialize(description)
      @description = description
      raise ArgumentError unless @description.is_a?(String)
    end

    def signature
      return @signature if defined?(@signature)
      match = self.description.split(/\n/)[0].match(SIGNATURE_REX) or return [[]]
      sig = match[1].scan(/#{CLASS_PAT}( #{VAR_PAT})?/o).map do |type, variable|
        begin
          type = Object.const_get(type.to_sym)
        rescue NameError
          raise NameError, "Invalid signature type: #{type.to_sym}"
        end
        variable.nil? ? [type] : [type, variable.strip.to_sym]
      end
      sig << [match[2]] if !match[2].nil? && match[3]
      @signature = sig.empty? ? [[]] : sig
    end

    def returns
      return @returns if defined?(@returns)
      match = self.description.split(/\n/)[0][SIGNATURE_REX, 3] or return []
      @returns = match.scan(/#{RETURN_PAT}/o).map do |type|
        type = type.first
        if type.match(/(#{SELF_OR_BOOL_PAT})/)
          type
        else  
          begin
            Object.const_get(type.to_sym)
          rescue NameError
            raise NameError, "Invalid return type: #{type.to_sym}"
          end
        end
      end
    end

    def ok?
      [:returns, :signature].all? do |method|
        begin
          send(method)
        rescue NameError
          false
        end
      end and unique_paramaters?
    end

    def unique_paramaters?
      params = signature.map {|e| e.last}
      params == params.uniq
    end

    def signature_str
      block = signature.pop.first if signature.last.first.is_a?(String)
      sig = self.signature.map do |element|
        element.size == 2 ? element.join(' ') : element.first
      end
     sig = '(' + sig.join(', ') +')'
     sig << " #{block}" if block 
     sig
    end

    def returns_str
      self.returns.join(' or ')
    end

    def to_s
      "#{signature_str} => #{returns_str}"
    end
  end

  class InvalidSignatureError < Exception
    def initialize(signature)
      super signature.to_s
    end
  end
end
