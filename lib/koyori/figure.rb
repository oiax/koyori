module Koyori
  class Figure
    def initialize(src, title)
      @src = src
      @title = title
    end

    def format
      number = self.class.increment_number
      "<div class='figure'>" +
        "<img src='#{@src}' title='#{@title}' /><br />" +
        "<span class='caption'>図#{number} #{@title}</span>" +
        "</div>"
    end

    class << self
      def current_number
        @number ||= 0
        @number
      end

      def next_number
        current_number + 1
      end

      def increment_number
        @number += 1
        @number
      end
    end
  end
end
