module Koyori
  class Chapter
    def initialize(source)
      @source = source
    end

    def to_html
      html = ''
      line_number = 0
      mode = 'normal'
      path = nil
      buffer = ''
      @source.gsub(/\r\n?/, "\n").each_line do |line|
        line_number += 1
        line.chomp!

        case line
        when /\A(\#{1,6})\s+(.*)/
          level = Regexp.last_match[1].length
          text = Regexp.last_match[2]
          html << Koyori::Heading.new(level, text).format
        when /\A```(?:\[([^\]]+)\])?/
          if mode == 'normal'
            mode = 'pre'
            buffer = ''
            if Regexp.last_match[1]
              path = Regexp.last_match[1]
            end
          else
            html << Koyori::Pre.new(buffer, path).format
            path = nil
            mode = 'normal'
          end
        else
          if mode == 'pre'
            buffer << line + "\n"
          else
            if line.match(/\A\s*\z/)
              html << "\n"
            else
              html << Koyori::Paragraph.new(line).format
            end
          end
        end
      end
      html
    end
  end
end
