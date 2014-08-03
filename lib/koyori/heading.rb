require 'cgi'

module Koyori
  class Heading
    def initialize(level, text)
      @level = level
      @text = text
      toc = Koyori::Toc.get
      @element_id = case level
      when 1
        toc.add_chapter(text)
      when 2
        toc.add_section(text)
      when 3
        toc.add_subsection(text)
      end
    end

    def format
      if @element_id
        "<h#{@level} id='#{@element_id}'>" + Koyori::Text.new(@text).format + "</h#{@level}>"
      else
        "<h#{@level}>" + Koyori::Text.new(@text).format + "</h#{@level}>"
      end
    end
  end
end
