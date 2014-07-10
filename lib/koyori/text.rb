module Koyori
  class Text
    LEFT_PAREN = '（'
    RIGHT_PAREN = '）'
    START_CODE = '《'
    END_CODE = '》'
    START_PROTECTION = '【'
    END_PROTECTION = '】'
    ASCII_CHARS = '\\x20-\\x7f'
    ENGLISH_CHARS = '[a-z]+(, [a-z]+)*'
    TEXT_CHARS = '^' + ASCII_CHARS + LEFT_PAREN + RIGHT_PAREN +
      START_CODE + END_CODE + START_PROTECTION + END_PROTECTION
    PROTECTED_WORDS = if File.exist?('PROTECTED_WORDS')
      File.open('PROTECTED_WORDS').read.split(/(\r?\n)+/).reject { |e| e.match(/\A\s*\z/) }
    else
      []
    end

    def initialize(content)
      @content = content
    end

    def format
      buffer = ''

      while(@content.length > 0)
        @content = @content.sub(%r!\A#{LEFT_PAREN}#{ENGLISH_CHARS}+#{RIGHT_PAREN}!, '')
        if Regexp.last_match
          buffer << CGI.escapeHTML(Regexp.last_match[0])
          next
        end
        @content = @content.sub(%r!\A[#{LEFT_PAREN}#{RIGHT_PAREN}]!, '')
        if Regexp.last_match
          buffer << Regexp.last_match[0]
          next
        end
        @content = @content.sub(%r!\A#{START_CODE}.*?#{END_CODE}!, '')
        if Regexp.last_match
          buffer << add_code_tags(Regexp.last_match[0])
          next
        end
        @content = @content.sub(%r!\A#{START_PROTECTION}.*?#{END_PROTECTION}!, '')
        if Regexp.last_match
          buffer << CGI.escapeHTML(Regexp.last_match[0])
          next
        end
        @content = @content.sub(%r!\A[#{TEXT_CHARS}]+!, '')
        if Regexp.last_match
          buffer << CGI.escapeHTML(Regexp.last_match[0])
          next
        end
        @content = @content.sub(%r!\A[#{ASCII_CHARS}]*!, '')
        if Regexp.last_match
          buffer << add_code_tags(Regexp.last_match[0])
        end
      end

      buffer
    end

    def add_code_tags(string)
      if string.match(/\s*(\d+)(\.\d+|\.[xyz]){0,2}\s*\z/)
        stem = Regexp.last_match.pre_match
        suffix = Regexp.last_match[0]
      else
        stem = string
        suffix = ''
      end

      if PROTECTED_WORDS.include?(stem)
        stem + suffix
      elsif string.match(%r!\A[ 0-9]*\z!)
        string
      else
        "<code>#{CGI.escapeHTML(string)}</code>"
      end
    end
  end
end
