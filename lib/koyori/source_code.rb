require 'cgi'

module Koyori
  class SourceCode
    def initialize(text, path, starting_line_number)
      @text = text
      @path = path
      @starting_line_number = starting_line_number
    end

    def format
      buffer = ''
      buffer << "<pre class='source-code'>\n"
      buffer << "<div class='path'>#{@path}</div>\n"
      @line_number = 1
      @text.split(/\n/).each_with_index do |line, index|
        case line
        when %r{\s*\((\d+)-(\d+)行省略\)\s*}
          s = Regexp.last_match[1].to_i
          e = Regexp.last_match[2].to_i
          error("Numbering error", line, index) unless s < e
          unless s == @line_number
            error("Numbering mismatch #{s} != #{@line_number}", line, index)
          end
          @line_number = e
          buffer << "<span class='num'>\u22ef</span>\n"
        when %r{\s*\(以下省略\)\s*}
          buffer << "<span class='num'>\u22ef</span>\n"
        else
          buffer << process(line)
          @line_number += 1
        end
      end
      buffer << '</pre>'
      buffer
    end

    private
    def process(line)
      buffer = ''
      buffer << sprintf("<span class='num'>%03d:</span> ", @line_number)
      buffer << line
      buffer << "\n"
      buffer
    end

    def error(message, src, index)
      puts "#{message} on line #{@starting_line_number + index}."
      puts src
      exit(false)
    end
  end
end
