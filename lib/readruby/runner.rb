module ReadRuby
  class Runner
    # Specification files need the MSpec gem to be loadable, but RubySpec's
    # spec_helper.rb doesn't require 'rubygems'.  
    require 'rubygems'

    def self.reset!
      @@invocations = []
    end

    def self.store(invocation)
      @@invocations ||= []
      @@invocations << invocation
    end

    def self.fetch
      @@invocations ||= []
    end

    def self.process_files(files)
      reset!
      files.each do |file|
        process_file file
      end
      display_all
    end

    def self.display_all
      fetch.each do |invocation|
        puts
        invocation.validate
        puts Formatter.new(invocation).text
      end
    end

    def self.process_file(file)
      @env = Object.new
      @env.extend(ReadRuby)
      @env.instance_eval { Kernel.load file }
    end
  end
end
