module Koyori
  class Div
    def initialize(directives)
      @directives = directives.to_s.split(/ +/)
    end

    def open_tag
      tag = "<div"
      @directives.each do |directive|
        case directive
        when /\A\.(.+)/
          tag << " class='#{Regexp.last_match[1]}'"
        when /\A\#(.+)/
          tag << " id='#{Regexp.last_match[1]}'"
        end
      end
      tag << ">"
      tag
    end
  end
end
