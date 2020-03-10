#! /usr/bin/env ruby

# require "HTTParty"
# require 'net/http'
# require 'json'

# get a 10-letter word, split and save to an array
word = 'absolutely'
word_arr = word.split("")
# puts word_arr.to_s

# randomly shuffle the letters
word_arr_shuffle = word_arr.shuffle
# puts "Shuffled array: #{word_arr_shuffle}"

letter_points = {
    'a': '1',
    'b': '3',
    'c': '3',
    'd': '2',
    'e': '1',
    'f': '4',
    'g': '2',
    'h': '4',
    'i': '1',
    'j': '8',
    'k': '5',
    'l': '1',
    'm': '3',
    'n': '1',
    'o': '1',
    'p': '3',
    'q': '10',
    'r': '1',
    's': '1',
    't': '1',
    'u': '1',
    'v': '4',
    'w': '4',
    'x': '8',
    'y': '4',
    'z': '10'
}

# fetch api data from words api and save to response
# url = ''
# response = HTTParty.get(url)
# puts response.parsed_responses

# uri = URI(url)
# response = Net::HTTP.get(uri)
# puts JSON.parse(response)

require 'net/https'
require 'httparty'   # gem install httpparty
response = nil
# word = 'small'
uri = URI('https://od-api.oxforddictionaries.com:443/api/v2/entries/en-gb/' + word)
use_ssl = true
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = use_ssl
http.start do |http|
   req = Net::HTTP::Get.new(uri)
   req['app_id'] = 'a64687ef'
   req['app_key'] = '5a1197b3e1f21172c523911f13c914ed'
   req['Accept'] = 'application/json'
   response = http.request(req)
   resp = response.body
  if resp
    puts "word is valid"
  end



end