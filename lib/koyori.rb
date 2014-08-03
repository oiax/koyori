require 'rubygems'
require 'nokogiri'
require 'html_builder'
Dir["#{File.dirname(__FILE__)}/koyori/*.rb"].sort.each do |path|
  require "koyori/#{File.basename(path, '.rb')}"
end
