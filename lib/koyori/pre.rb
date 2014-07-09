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
        buffer = "<div class='path'>#{@path}</div>\n"
      end
      buffer << '<pre><code>'
      @text.each_line do |line|
        buffer << CGI.escapeHTML(line)
      end
      buffer << '</code></pre>'
      buffer
    end
  end
end
