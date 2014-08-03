require 'cgi'

module Koyori
  class Excerpt
    def initialize(text)
      @text = text
    end

    def format
      buffer = "<div class='excerpt'>\n"
      @text.each_line do |line|
        line.chomp!
        if line.sub!(/\A\s+/, '')
          buffer << Regexp.last_match[0].gsub(/ /, '&nbsp;')
        end
        buffer << CGI.escapeHTML(line)
        buffer << "<br />\n"
      end
      buffer << '</div>'
      buffer
    end
  end
end
