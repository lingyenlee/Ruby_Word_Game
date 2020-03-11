#! /usr/bin/env ruby

require 'net/https'
require 'httparty' 
require 'json'
require 'tty-prompt'


# randomly shuffle word
def shuffle_word(word)
    arr = word.split("").shuffle
     # randomly shuffle the letters
    shuffled_word = arr.join("")
    return shuffled_word
end

# track count of elements in array with hash
def make_hash(word)
    hash = {}
    word.each do |i|
        if hash.has_key?(i)
            hash[i] += 1
        else
            hash[i] = 1
        end
    end
    return hash
end

# find word in dictionary
def get_word(word)
    error_message = []
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

        # return my_resp['id']
        # if my_resp['id']
        if my_resp['id'] == word
            return true
        else 
            return false
        end
    end
end

def check_letter(shuffle, input)

    # make hash and store letter count
    shuffle_hash = make_hash(shuffle.split(""))
    input_hash = make_hash(input.split(""))
    diff = []

    input_hash.each do |k, v|
        if shuffle_hash.has_key?(k) && v > shuffle_hash[k]
            diff.push(k)
        elsif !shuffle_hash.has_key?(k)
            diff.push(k)
        else
            next
        end
    end
    return diff
end

# count word score
def get_word_score(word_input, score, threshold)

    # scores for each letter
    score_key = {
        "a" => 1, "b" => 3, "c" => 3, "d" => 2, "e" => 1, "f" => 4, "g" => 2, "h" => 4, "i" => 1, 
        "j" => 8, "k" => 5, "l" => 1, "m" => 3, "n" => 1, "o" => 1, "p" => 3, "q" => 10, "r" => 1, 
        "s" => 1, "t" => 1, "u" => 1, "v" => 4, "w" => 4, "x" => 8, "y" => 4, "z" => 10 }

    # initialize total score and input number
    word_score = 0
 
    # map through each letter in word and count score
    word_input.chars {|x| word_score += score_key[x]}
    puts "Your word score is #{word_score}."
    
    total_score = score + word_score 
    puts "Total score is #{total_score}."
    if threshold > total_score
        puts "You need #{threshold-total_score} more points to win. Keep it up!"
    else
        puts "You have scored extra #{total_score-threshold} points!"
    end
    return total_score
  
end

# get results
def results(score, level)
    if score >= level
        return "Your total score is #{score}, higher than #{level} points needed, you win!"
    else
        return "Your total score is #{score} lower than #{level} points needed, sorry not your day! Try harder next time!"
    end
end


def play_game

    prompt = TTY::Prompt.new
 
     # get name
    name = prompt.ask("What is your name?")
    
    while true
          # display menu of play levels
        play_level = prompt.select("Hello #{name}, choose play level") do |level|
            level.default 1
        
            level.choice "Easy (10 pts to win)", 1
            level.choice "Medium (20 pts to win)", 2
            level.choice "Hard (30 pts to win)", 3
        end

        # check for correct input for play level
        while play_level == 1 || play_level == 2 || play_level == 3
            case play_level
            when 1
                score_threshold = 10
                break
            when 2
                score_threshold = 20
                break
            when 3
                score_threshold = 40
                break
            else
                puts "You entry is not valid. Please choose again"
            end
        end    

        # present shuffle word
        word_to_play = "consolidate"
        shuffled_word = shuffle_word(word_to_play)
        puts "Your word is #{shuffled_word}."
        
        # initialize values
        arr = []
        i = 1
        total_score = 0

        while i < 4
        
            # get word input and save to an array and make a hash to keep trash
            word_input = prompt.ask("Make a word from #{shuffled_word} - Input #{i}")
            
            # save word to array and hash counter
            arr.push(word_input)
            track_word_input = make_hash(arr)
        
            # get return value of word and letter checks 
            check_word = get_word(word_input)
            check_letter = check_letter(shuffled_word, word_input)
        
            # check for invalid inputs
            if !check_word
                puts "Invalid word. Try again."
                word_input 
                next
            elsif check_letter.length > 0 
                puts "Letter(s) not found or more than in word. Try again."
                word_input 
                next
            elsif track_word_input[word_input] > 1
                puts "Word has been used. Try again."
                word_input 
                next
            else
                puts "Valid word."
            end
            i += 1

            # get word score and total score
            total_score = get_word_score(word_input, total_score, score_threshold)
        end

        # display final results
        puts results(total_score, score_threshold)

        # ask if player wants to play again
        play_again = prompt.yes?("Do you want to play again (y/n).")
        if !play_again
            puts "Bye!"
            break
        end
    end
end

 play_game
