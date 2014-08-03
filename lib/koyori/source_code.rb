require 'cgi'

module Koyori
  class SourceCode
    MOD_SIGN = '◆'
    DEL_SIGN = '◇'

    def initialize(text, path, starting_line_number)
      @text = text
      @path = path
      @starting_line_number = starting_line_number
      @mode = 'normal'
    end

    def format
      buffer = ''
      buffer << "<div class='source-code'>\n"
      buffer << "<span class='path'>#{@path}</span><br />\n"
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
          buffer << "<font color='#888'>\u22ef</font><br />\n"
        when %r{\s*\(以下省略\)\s*}
          buffer << "<font color='#888'>\u22ef</font><br />\n"
        else
          buffer << process(line)
          @line_number += 1
        end
      end
      buffer << '</div>'
      buffer
    end

    private
    def process(line)
      buffer = ''
      buffer << sprintf("<span class='num'>%03d:</span> ", @line_number)
      buffer << add_tags(line)
      buffer << "<br />\n"
      buffer
    end

    def add_tags(line)
      buffer = ''
      str = line.dup
      if str.sub!(/\A\s+/, '')
        buffer << Regexp.last_match[0].gsub(/ /, '&nbsp;')
      end
      if @mode == 'modified'
        buffer << "<span style='font-family: UbuntuMono; font-weight: bold'>"
      elsif @mode == 'deleted'
        buffer << "<del>"
      end
      while str.length > 0
        case @mode
        when 'normal'
          if str.match(/\A[^#{MOD_SIGN}#{DEL_SIGN}]+/)
            buffer << CGI.escapeHTML(Regexp.last_match[0])
            str = Regexp.last_match.post_match
          elsif str.match(/\A#{MOD_SIGN}/)
            buffer << "<span style='font-family: UbuntuMono; font-weight: bold'>"
            str = Regexp.last_match.post_match
            @mode = 'modified'
          elsif str.match(/\A#{DEL_SIGN}/)
            buffer << "<del>"
            str = Regexp.last_match.post_match
            @mode = 'deleted'
          else
            raise
          end
        when 'modified'
          if str.match(/\A[^#{MOD_SIGN}]+/)
            buffer << CGI.escapeHTML(Regexp.last_match[0])
            str = Regexp.last_match.post_match
          elsif str.match(/\A#{MOD_SIGN}/)
            buffer << "</span>"
            str = Regexp.last_match.post_match
            @mode = 'normal'
          end
        when 'deleted'
          if str.match(/\A[^#{DEL_SIGN}]+/)
            buffer << CGI.escapeHTML(Regexp.last_match[0])
            str = Regexp.last_match.post_match
          elsif str.match(/\A#{DEL_SIGN}/)
            buffer << "</del>"
            str = Regexp.last_match.post_match
            @mode = 'normal'
          end
        end
      end
      if @mode == 'modified'
        buffer << "</b>"
      elsif @mode == 'deleted'
        buffer << "</del>"
      end
      buffer
    end

    def error(message, src, index)
      puts "#{message} on line #{@starting_line_number + index}."
      puts src
      exit(false)
    end
  end
end
