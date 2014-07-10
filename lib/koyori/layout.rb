module Koyori
  class Layout
    def initialize(body, config)
      @body = body
      @config = config
      @title = config['title'] || 'NO TITLE'
    end

    def output
      basedir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
      path1 = File.expand_path(File.join(basedir, 'templates', 'layout.html'))
      path2 = File.expand_path(File.join(basedir, 'templates', 'default.css'))
      html = File.open(path1).read
      css = File.open(path2).read.chomp
      html.sub(/%TITLE%/, @title)
        .sub(/%BODY%/, @body)
        .sub(%r{</style>}, "\n#{css}\n</style>")
    end
  end
end
