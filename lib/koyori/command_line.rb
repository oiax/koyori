require 'cgi'

module Koyori
  class CommandLine
    def initialize(text)
      @text = text
    end

    def format
      buffer = ''
      buffer << "<div class='command-line'>\n"
      @line_number = 1
      @text.split(/\n/).each_with_index do |line, index|
        if line.match(/^[>%$] /)
          prompt = Regexp.last_match[0]
          command = Regexp.last_match.post_match
          buffer << prompt.sub(/^([>%$])/, '<span class="prompt">\1</span>')
          buffer << CGI.escapeHTML(command)
        else
          buffer << CGI.escapeHTML(line)
        end
        buffer << "<br />\n"
      end
      buffer << "</div>"
      buffer
    end
  end
end
