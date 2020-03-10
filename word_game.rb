#! /usr/bin/env ruby

require 'net/https'
require 'httparty'   # gem install httpparty
require 'json'

def shuffle_word(word)

    word_arr = word.split("").shuffle
     # randomly shuffle the letters
    shuffle_word = word_arr.join("")

     return "Your word is #{shuffle_word}."
end

def check_letter(word, input)
    word_array = word.split("")
    input_array = input.split("")

end

# method to check word validity
def check_word(word)

    response = nil
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
        # parse Json to Hash
        my_resp = JSON.parse(resp)
        if my_resp['id'] == word
            return "Word is valid."
        else 
            return "Word not found."
        end
        
    end
end


# count word score
def word_score(word)

    # scores for each letter
    score_key = {
        "A" => 1, "B" => 3, "C" => 3, "D" => 2, "E" => 1, "F" => 4, "G" => 2, "H" => 4, "I" => 1, 
        "J" => 8, "K" => 5, "L" => 1, "M" => 3, "N" => 1, "O" => 1, "P" => 3, "Q" => 10, "R" => 1, 
        "S" => 1, "T" => 1, "U" => 1, "V" => 4, "W" => 4, "X" => 8, "Y" => 4, "Z" => 10 }

    # initialize point
    points = 0
    
    # convert word to upper case
    word=word.upcase
 
    # map through each char and add points
    word.chars {|x| points += score_key[x]}
    puts "Your word score is #{points}."
    return points
end

# def sum(scores)
#     scores.reduce(0, :+)
#     return "Your total score is #{score}"
# end

# shuffle_word = shuffle_word("consolidation")

# get response from input
def get_response(prompt_text)
    print prompt_text
    response = gets.chomp
    return response
end

# get results
def results(word, level)

    points_score = word_count(word)
    if points_score >= level
        puts "Your total score is #{points_score} more than the required #{level}, you win!"
    else
        puts "Your total score is #{points_score} less than the required #{level}, you lose!"
    end
end



# 3 words input
def word_input
    i = 1
    while i < 4 
        word_input = get_response("Entry #{i} make a word: ")
        puts check_word(word_input)
        points = word_score(word_input)
        puts sum(points)
        i += 1
    end
end

def play_game
    
    # get name
    name = get_response("What is your name? ")
    
    # get level of difficulty
    play_level = get_response("Hello #{name}, choose play level (points to win): 1 for Easy (20pts), 2 for Medium (30pts), 3 for Difficult (50pts) ")
    
    # present shuffle word
    word_to_play = "consolidate"
    puts shuffle_word(word_to_play)
    
    word_input

end


# word_input
play_game







