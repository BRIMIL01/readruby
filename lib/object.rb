class Object
  def doc(object, *args)
    @object = object
    raise ArgumentError unless @object.is_a?(Class)
    @description = args.pop
    raise ArgumentError unless @description.is_a?(String)
    @methods = args
    raise ArgumentError unless @methods.all? {|m| m.is_a?(Symbol)}
    raise ArgumentError unless @methods.size > 0
    raise ArgumentError unless @methods == @methods.uniq
    @methods.map do |method|
      ReadRuby::Invocation.new(@object, method, @description)
    end
  end
end
