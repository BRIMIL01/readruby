class Object
  MSPEC_METHODS = %w{it describe it_behaves_like quarantine! as_superuser
                     as_user ruby_version_is platform_is ruby_bug}
  MSPEC_METHODS.each do |method|
    next if Object.respond_to?(method.to_sym)
    Object.send(:define_method, method.to_sym) {|*a|}
  end

  def doc(object, *args)
    @object = object
    raise ArgumentError unless @object.is_a?(Class)
    @description = args.pop
    raise ArgumentError unless @description.is_a?(String)
    @methods = args
    raise ArgumentError unless @methods.all? {|m| m.is_a?(Symbol)}
    raise ArgumentError unless @methods.size > 0
    raise ArgumentError unless @methods == @methods.uniq
    @methods.map! do |method|
      invoc = ReadRuby::Invocation.new(@object, method, @description)
      ReadRuby::Runner.store invoc
      invoc
    end
    @methods
  end
end
