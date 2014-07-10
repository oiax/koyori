module Koyori
  class List
    def initialize(text)
      @text = text
    end

    def format(tag, regexp)
      buffer = "<#{tag}>\n"
      @current_level = nil
      @text.each_line do |line|
        unless line.match(regexp)
          raise "#{line}, #{tag}"
        end
        level = Regexp.last_match[1].length / 2
        content = Koyori::Text.new(Regexp.last_match[2]).format
        if @current_level == nil
          buffer << "<li>#{content}"
        elsif level == @current_level
          buffer << "</li>\n"
          buffer << "<li>#{content}"
        elsif level == @current_level + 1
          buffer << "\n<#{tag}>\n"
          buffer << "<li>#{content}"
        elsif level < @current_level
          (@current_level - level).times do
            buffer << "</li>\n"
            buffer << "</#{tag}>\n"
          end
          buffer << "</li>\n"
          buffer << "<li>#{content}"
        end
        @current_level = level
      end

      @current_level.times do
        buffer << "</li>\n"
        buffer << "</#{tag}>\n"
        buffer << "</li>\n"
      end

      buffer << "</li>\n"
      buffer << "</#{tag}>\n"
      buffer
    end
  end

  class UnorderedList < List
    def format
      super('ul', /\A(\s{2}*)\*\s+(.*)/)
    end
  end

  class OrderedList < List
    def format
      super('ol', /\A(\s{2}*)\d\.\s+(.*)/)
    end
  end
end
