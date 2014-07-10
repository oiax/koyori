module Koyori
  class Chapter
    def initialize(source)
      @source = source
    end

    def to_html
      @html = ''
      @line_number = 0
      @mode = 'normal'
      @path = nil
      @buffer = ''
      @source.gsub(/\r\n?/, "\n").each_line do |line|
        @line_number += 1
        line.chomp!

        case @mode
        when 'normal'
          format_in_normal_mode(line)
        when 'div'
          format_in_div_mode(line)
        when 'unordered_list'
          format_in_unordered_list_mode(line)
        when 'ordered_list'
          format_in_ordered_list_mode(line)
        when 'pre'
          format_in_pre_mode(line)
        else
          raise
        end
      end

      @html
    end

    private
    def format_in_normal_mode(line)
      case line
      when /\A(\#{1,6})\s+(.*)/
        level = Regexp.last_match[1].length
        text = Regexp.last_match[2]
        @html << Koyori::Heading.new(level, text).format
      when %r{\A<div[^>]*>\s*\z}
        @html << line + "\n"
        @mode = 'div'
      when %r{\A%%%\s*(.*)\z}
        @html << Koyori::Div.new(line).open_tag
        @mode = 'div'
      when /\A\*\s+(.*)/
        @mode = 'unordered_list'
        @buffer = line + "\n"
      when /\A\d\.\s+(.*)/
        @mode = 'ordered_list'
        @buffer = line + "\n"
      when /\A```(?:\[([^\]]+)\])?/
        @mode = 'pre'
        @buffer = ''
        if Regexp.last_match[1]
          @path = Regexp.last_match[1]
        end
      else
        if line.match(/\A\s*\z/)
          @html << "\n"
        else
          @html << Koyori::Paragraph.new(line).format
        end
      end
    end

    def format_in_div_mode(line)
      case line
      when %r{\A</div>\s*\z}
        @html << "\n" + line
        @mode = 'normal'
      when %r{\A%%%\s*\z}
        @html << "</div>\n"
        @mode = 'normal'
      else
        if line.match(/\A\s*\z/)
          @html << "\n"
        else
          @html << Koyori::Paragraph.new(line).format
        end
      end
    end

    def format_in_unordered_list_mode(line)
      case line
      when /\A(\s\s)*\*\s+(.*)/
        @buffer << line + "\n"
      else
        @html << Koyori::UnorderedList.new(@buffer).format
        @mode = 'normal'
        format_in_normal_mode(line)
      end
    end

    def format_in_ordered_list_mode(line)
      case line
      when /\A(\s\s)*\d\.\s+(.*)/
        @buffer << line + "\n"
      else
        @html << Koyori::OrderedList.new(@buffer).format
        @mode = 'normal'
        format_in_normal_mode(line)
      end
    end

    def format_in_pre_mode(line)
      case line
      when /\A```\s*\z/
        if @path && @path != ''
          @html << Koyori::SourceCode.new(@buffer, @path).format
        else
          @html << Koyori::Excerpt.new(@buffer).format
        end
        @buffer = ''
        @path = nil
        @mode = 'normal'
      else
        @buffer << line + "\n"
      end
    end
  end
end
