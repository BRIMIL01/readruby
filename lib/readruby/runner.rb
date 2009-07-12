module ReadRuby
  class Runner
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
        puts invocation
      end
    end

    def self.process_file(file)
      @env = Object.new
      @env.extend(ReadRuby)
      @env.instance_eval { Kernel.load file }
    end
  end
end
