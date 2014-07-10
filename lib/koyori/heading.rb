require 'cgi'

module Koyori
  class Heading
    def initialize(level, text)
      @level = level
      @text = text
    end

    def format
      "<h#{@level}>" + Koyori::Text.new(@text).format + "</h#{@level}>"
    end
  end
end
