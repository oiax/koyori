module Koyori
  class Toc
    include HtmlBuilder

    attr_reader :chapters, :preface_heading

    def initialize
      @chapters = []
      @chapter_number = 0
      @section_number = 0
      @subsection_number = 0
      @preface_heading = nil
    end

    def add_chapter(heading)
      @chapters << {
        heading: heading,
        sections: []
      }
      @chapter_number += 1
      @section_number = 0
      sprintf "chapter-%02d", @chapter_number
    end

    def add_section(heading)
      chapter = @chapters.last || raise("No current chapter")
      chapter[:sections] << {
        heading: heading,
        subsections: []
      }
      @section_number += 1
      @subsection_number = 0
      sprintf "section-%02d-%02d", @chapter_number, @section_number
    end

    def add_subsection(heading)
      chapter = @chapters.last || raise("No current chapter")
      section = chapter[:sections].last || raise("No current section")
      section[:subsections] << heading
      @subsection_number += 1
      sprintf "subsection-%02d-%02d-%02d", @chapter_number, @section_number, @subsection_number
    end

    def set_preface_heading(heading)
      @preface_heading = heading
    end

    def to_html
      markup('nav', 'epub:type' => 'toc', 'id' => 'nav') do |m|
        m.h1 '目次'
        m.ol do
          @chapters.each_with_index do |chapter, i|
            m.li do
              m.a(href: sprintf("#chapter-%02d", i + 1)) do
                m << chapter[:heading]
              end
              next if chapter[:sections].empty?
              m.ol do
                chapter[:sections].each_with_index do |section, j|
                  m.li do
                    m.a(href: sprintf("#section-%02d-%02d", i + 1, j + 1)) do
                      m << section[:heading]
                    end
                    next if section[:subsections].empty?
                    m.ol do
                      section[:subsections].each_with_index do |subsection, k|
                        m.li do
                          m.a(href: sprintf("#subsection-%02d-%02d-%02d", i + 1, j + 1, k + 1)) do
                            m << subsection
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    def to_nav_map
      builder = Nokogiri::XML::Builder.new do |m|
        m.ncx do
          m.navMap do
            if @preface_heading
              m.navPoint(:class => 'preface', :id => 'preface', :playOrder => 0) do
                m.navLabel do
                  heading = @preface_heading
                  heading.gsub!(%r{</?\w+[^>]*>}, '')
                  m << "<text>#{heading}</text>\n"
                end
                m.content(:src => "book.html#preface")
              end
            end
            @chapters.each_with_index do |chapter, i|
              m.navPoint(:class => 'chapter', :id => sprintf("chapter-%02d", i + 1), :playOrder => i + 1) do
                m.navLabel do
                  heading = chapter[:heading]
                  heading.gsub!(%r{</?\w+[^>]*>}, '')
                  m << "<text>Chapter #{i + 1} #{heading}</text>\n"
                end
                m.content(:src => sprintf("book.html#chapter-%02d", i + 1))
              end
            end
          end
        end
      end
      builder.to_xml
    end

    class << self
      def get
        @singleton ||= self.new
      end
    end
  end
end
