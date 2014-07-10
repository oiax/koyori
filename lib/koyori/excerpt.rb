require 'cgi'

module Koyori
  class Excerpt
    def initialize(text)
      @text = text
    end

    def format
      buffer = "<pre class='excerpt'>\n"
      @text.each_line do |line|
        buffer << CGI.escapeHTML(line)
      end
      buffer << '</pre>'
      buffer
    end
  end
end
