module Koyori
  class Chapter
    def initialize(source)
      @source = source
    end

    def to_html
      html = ''
      line_number = 0
      @source.gsub(/\r\n?/, "\n").each_line do |line|
        line_number += 1
        line.chomp!

        case line
        when /\A(\#{1,6})\s+(.*)/
          level = Regexp.last_match[1].length
          text = Regexp.last_match[2]
          html << Koyori::Heading.new(level, text).format
        else
          html << Koyori::Paragraph.new(line).format
        end
      end
      html
    end
  end
end
