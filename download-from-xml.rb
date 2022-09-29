#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

class Parser
    def initialize(file_name)
        @file = Nokogiri::XML(File.open(file_name))
        @file.remove_namespaces!
    end

    def matchXpath(xpath)
        results = Array.new
        for result in @file.xpath(xpath) do
            results << result.content
        end
        return results
    end
end


puts 'Which .xml file contains the links needed to download?'
# reads input and ignores newline
file_name = gets.chomp.strip

puts 'Which tags are links stored in?'
tag = "//" + gets.chomp.strip

puts 'Enter a string to filter links (optional, press enter to continue)'
keyword = gets.chomp.strip

puts 'Which file should results be downloaded to?'
output = gets.chomp.strip

file_parser = Parser.new(file_name)
urls = file_parser.matchXpath(tag)

matches = urls.select{|x| x.match(keyword) }

for match in matches do
    puts match
    download = URI.open(match)
    IO.copy_stream(download, output + "#{download.base_uri.to_s.split('/')[-1]}")
end

