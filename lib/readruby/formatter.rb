module ReadRuby
  class Formatter
  
    attr_reader :invoc

    def initialize(invocation)
      @invoc = invocation
      raise ArgumentError unless @invoc.is_a?(Invocation)
    end
    
    def html
      self.class.markdown.new(self.text).to_html.chomp
    end

    def text
      txt = "    #{invoc.object}##{invoc.method}#{invoc.signature.to_s}"
      txt << "\n\n#{invoc.description.join}" unless invoc.description.empty?
      unless invoc.examples.empty?
        txt << <<-examples


## Examples

#{invoc.examples.map {|e| e.to_s }.join("\n")}
        examples
      end
      txt
    end

    def self.markdown
      return @@markdown if defined?(@@markdown)
      @@markdown = nil
      require 'rubygems'
      %w{RDiscount Maruku BlueCloth}.each do |lib| 
        begin
          require lib.downcase
          return @@markdown = Object.const_get(lib)
        rescue LoadError
        end
      end or raise LoadError, "No Markdown converter found"
    end
  end
end
