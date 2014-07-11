module Koyori
  class Div
    def initialize(directives, heading = nil)
      @directives = directives.to_s.split(/ +/)
      @heading = heading
    end

    def open_tag
      tag = "<div"
      html_classes = []
      @directives.each do |directive|
        case directive
        when /\A\.(.+)/
          tag << " class='#{Regexp.last_match[1]}'"
        when /\A\#(.+)/
          tag << " id='#{Regexp.last_match[1]}'"
        end
      end
      if @heading
        html_classes << 'column'
      end
      tag << " class='#{html_classes.join(' ')}'" unless html_classes.empty?
      tag << ">"
      if @heading
        tag << "\n"
        tag << "<h3 class='column'>#{Koyori::Text.new(@heading).format}</h3>"
      end
      tag
    end
  end
end
