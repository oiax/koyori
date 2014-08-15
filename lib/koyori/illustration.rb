module Koyori
  class Illustration
    def initialize(src)
      @src = src
    end

    def format
      "<div class='illustration'><img src='#{@src}' /></div>"
    end
  end
end
