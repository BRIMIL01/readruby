module ReadRuby
  class Description

    attr_accessor :text

    def initialize(description)
      @text = description
      raise ArgumentError unless @text.is_a?(String)
    end

    def html
      self.class.markdown.new(self.text).to_html.chomp
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
