module Koyori
  class Config
    def initialize
      @yaml = YAML.load_file('config.yml')
    end

    def [](key)
      @yaml[key]
    end

    def to_opf
      builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |m|
        m.package(xmlns: 'http://www.idpf.org/2007/opf', version: '2.0') do
          m.metadata do
            m.send('dc-metadata',
              'xmlns:dc' => 'http://purl.org/metadata/dublin_core',
              'xmlns:oebpackage' => 'http://openebook.org/namespaces/oeb-package/1.0/') do
              m['dc'].language @yaml['language']
              m['dc'].creator @yaml['author']
              m['dc'].title @yaml['title']
              m['dc'].publisher @yaml['publisher']
              m['dc'].date @yaml['date']
            end
            m.meta name: 'cover', content: 'cover-image'
          end
          m.manifest do
            m.item id: 'cover-image', 'media-type' => 'image/jpg', href: 'cover.jpeg'
            m.item id: 'content', 'media-type' => 'application/xhtml+xml', href: 'book.html'
            m.item id: 'toc', 'media-type' => 'application/x-dtbncx+xml', href: 'toc.ncx'
          end
          m.spine(toc: 'toc') do
            m.itemref idref: 'cover-image'
            m.itemref idref: 'content'
          end
          m.guide do
            m.reference type: 'toc', title: '目次', href: 'book.html%23nav'
            m.reference type: 'preface', title: 'はじめに', href: 'book.html%23preface'
            m.reference type: 'text', title: '本文', href: 'book.html%23chapter-01'
          end
        end
      end
      builder.to_xml
    end
  end
end
