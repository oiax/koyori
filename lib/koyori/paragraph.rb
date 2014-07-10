require 'cgi'

module Koyori
  class Paragraph
    def initialize(content)
      @content = content
    end

    def format
      "<p>" + Koyori::Text.new(@content).format + "</p>"
    end
  end
end
