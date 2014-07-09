require 'cgi'

module Koyori
  class Paragraph
    def initialize(text)
      @text = text
    end

    def format
      "<p>#{CGI.escapeHTML(@text)}</p>"
    end
  end
end
