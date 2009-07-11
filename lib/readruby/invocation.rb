module ReadRuby
  class Invocation
    
    attr_accessor :object, :method

    def initialize(object, method, description)
      @object, @method, @description = object, method, description
      raise ArgumentError unless @object.is_a?(Class)
      raise ArgumentError unless @method.is_a?(Symbol)
      raise ArgumentError unless @description.is_a?(String)
      raise NoMethodError, "#{object}##{method}" unless valid_method?
    end

    def description
      Description.new(@description)
    end

    def signature
      signature_object.signature
    end

    def returns
      signature_object.returns
    end

    private
    def valid_method?
      self.object.method_defined?(self.method) ||
      # We use this ugly construct so as to be compatiable with both 1.8,
      # where .singleton_methods returned Strings, and 1.9, where it returns
      # Symbols 
      self.object.singleton_methods.any? {|m| m.to_sym == self.method }
    end

    def signature_object
      @signature_obj ||= Signature.new(self.description.text)
    end
  end
end
