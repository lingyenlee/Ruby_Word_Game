# word = "affordable"
# array = word.split("")

# puts array.to_s
# shuffle = array.shuffle
# puts shuffle.to_s


require 'nokogiri'
require 'open-uri'
require 'json'
# require 'pry'
# Fetch and parse HTML document
doc = Nokogiri::HTML(open('https://wordfinder.yourdictionary.com/letter-words/10/'))

words = []

# table = doc.at("table")
# table.search('td.table-cell-word').each do |i|
#     words.push(i.content)
# end

# puts words
# # binding.pry
# puts doc

# puts "### Search for nodes by css"
# doc.css('nav ul.menu li a', 'article h2').each do |link|
#   puts link.content
# end

# puts "### Search for nodes by xpath"
# doc.xpath('//nav//ul//li/a', '//article//h2').each do |link|
#   puts link.content
# end

puts "### Or mix and match."
# rows = doc.css("td.table-cell-inner-con")
# puts rows
doc.search('td.table-cell-word').each do |link|
#     words = []
#   words.push(link.content)
puts link.content
#   puts words.to_s
end