require 'cgi'

module Koyori
  class SourceCode
    def initialize(text, path)
      @text = text
      @path = path
    end

    def format
      buffer = ''
      buffer << "<pre class='source-code'>\n"
      buffer << "<div class='path'>#{@path}</div>\n"
      @text.each_line do |line|
        buffer << CGI.escapeHTML(line)
      end
      buffer << '</pre>'
      buffer
    end
  end
end
