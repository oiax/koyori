require 'cgi'

module Koyori
  class Pre
    def initialize(text, path)
      @text = text
      @path = path
    end

    def format
      buffer = ''
      buffer << "<pre class='list'>\n"
      if @path && @path != ''
        buffer << "<span class='path'>#{@path}</span>\n"
      end
      @text.each_line do |line|
        buffer << CGI.escapeHTML(line)
      end
      buffer << '</pre>'
      buffer
    end
  end
end
