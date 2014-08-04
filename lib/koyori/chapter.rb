module Koyori
  class Chapter
    def initialize(source, file_name)
      @source = source
      @file_name = file_name
    end

    def to_html
      @html = ''
      @line_number = 0
      @buffer_start_line_number = nil
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
        when 'command_line'
          format_in_command_line_mode(line)
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
        if @file_name == 'preface.koy'
          @html << Koyori::PrefaceHeading.new(text).format
        else
          @html << Koyori::Heading.new(level, text).format
        end
      when %r{\A<div[^>]*>\s*\z}
        @html << line + "\n"
        @mode = 'div'
      when %r{\A%%%\[([^\]]+)\]\s*(.*)\z}
        heading = Regexp.last_match[1]
        directives = Regexp.last_match[2]
        @html << Koyori::Div.new(directives, heading).open_tag
        @mode = 'div'
      when %r{\A%%%\s*(.*)\z}
        directives = Regexp.last_match[1]
        @html << Koyori::Div.new(directives).open_tag
        @mode = 'div'
      when %r{\A\$\$\$\s*\z}
        @mode = 'command_line'
        @buffer = ''
      when %r{\A@@@\[([^\]]+)\]\[([^\]]+)\]\s*\z}
        src = Regexp.last_match[1]
        title = Regexp.last_match[2]
        @html << Koyori::Figure.new(src, title).format
      when /\A\*\s+(.*)/
        @mode = 'unordered_list'
        @buffer = line + "\n"
      when /\A\d\.\s+(.*)/
        @mode = 'ordered_list'
        @buffer = line + "\n"
      when /\A```(?:\[([^\]]+)\])?/
        @mode = 'pre'
        @buffer = ''
        @buffer_start_line_number = @line_number
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

    def format_in_command_line_mode(line)
      case line
      when %r{\A\$\$\$\s*\z}
        @html << Koyori::CommandLine.new(@buffer).format
        @buffer = ''
        @path = nil
        @mode = 'normal'
      else
        @buffer << line + "\n"
      end
    end

    def format_in_pre_mode(line)
      case line
      when /\A```\s*\z/
        if @path && @path != ''
          @html << Koyori::SourceCode.new(@buffer, @path, @buffer_start_line_number).format
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
