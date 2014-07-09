require 'cgi'

module Koyori
  class Heading
    def initialize(level, text)
      @level = level
      @text = text
    end

    def format
      "<h#{@level}>#{CGI.escapeHTML(@text)}</h#{@level}>"
    end
  end
end
