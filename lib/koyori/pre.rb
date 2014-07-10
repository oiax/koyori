require 'cgi'

module Koyori
  class Pre
    def initialize(text, path)
      @text = text
      @path = path
    end

    def format
      buffer = ''
      if @path && @path != ''
        buffer << "<pre class='list'>\n"
        buffer << "<div class='path'>#{@path}</div>\n"
      else
        buffer << "<pre class='excerpt'>\n"
      end
      @text.each_line do |line|
        buffer << CGI.escapeHTML(line)
      end
      buffer << '</pre>'
      buffer
    end
  end
end
