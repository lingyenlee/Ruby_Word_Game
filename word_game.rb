#! /usr/bin/env ruby

require 'net/https'
require 'httparty' 
require 'json'


# randomly shuffle word
def shuffle_word(word)
    word_arr = word.split("").shuffle
     # randomly shuffle the letters
    shuffle_word = word_arr.join("")

     return "Your word is #{shuffle_word}."
end

# get word input
def get_word_input(try)
    word_input = get_response("Make a word - Input #{try}: ")
    return word_input
end


# validate word - letters not repeated, word not repeated
def make_hash(word)
    hash = {}
    word.chars do |i|
        if hash.has_key?(i)
            hash[i] += 1
        else
            hash[i] = 1
        end
    end
    return hash
end

def get_err(message)
    return message
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

        # if my_resp['id']
        if my_resp['id'] == word
            return "Your word is valid."
        else 
            return false
        end
    end
end

def check_word(shuffle, input)

    error_message = []
    is_word = get_word(input)
    hash_shuffle = make_hash(shuffle)
    hash_input = make_hash(input)

    if !is_word
        error_message.push("Error - Invalid word. Try again.")
    end

    hash_input.each do |k, v|
        if !hash_shuffle.has_key?(k) 
            error_message.push("Error - letter(s) not found in word. Try again")
        elsif v > hash_shuffle[k]
            error_message.push("Error - repeated letter(s). Try again")
        else
            next
        end
    end
    return error_message
end

puts check_word("consolidate", "congratulate")


# count word score
def get_word_score(word_input)

    # scores for each letter
    score_key = {
        "a" => 1, "b" => 3, "c" => 3, "d" => 2, "e" => 1, "f" => 4, "g" => 2, "h" => 4, "i" => 1, 
        "j" => 8, "k" => 5, "l" => 1, "m" => 3, "n" => 1, "o" => 1, "p" => 3, "q" => 10, "r" => 1, 
        "s" => 1, "t" => 1, "u" => 1, "v" => 4, "w" => 4, "x" => 8, "y" => 4, "z" => 10 }

    # initialize total score and input number
    total_score = 0
    word_score = 0

    # word_input = get_word_input
    
    word_input.chars {|x| word_score += score_key[x]}
    puts "Your word score is #{word_score}."

    # accumulate and display score score
    total_score += word_score
    puts "Your total score is #{total_score}."

    
    # input_num = 1  
    
    # while input_num < 4 
        
    #     # ask for word input and convert word to upper case
        
    #     word_input = get_response("Make a word: ")
    
    #     # check word
    #     puts is_word(word_input)
       
    #     puts check_word(word_input)
       
    #     # initialize word_score and map through each char and add points
    #     word_score = 0
    #     word_input.chars {|x| word_score += score_key[x]}
    #     puts "Your word score is #{word_score}."

    #     # accumulate and display score score
    #     total_score += word_score
    #     puts "Your total score is #{total_score}."
    #     input_num += 1
    # end

    # return total_score
  
end

# shuffle_word = shuffle_word("consolidation")

# get response from input
def get_response(prompt_text)
    print prompt_text
    response = gets.chomp
    return response
end

# get results
def results(score, level)

    if score >= level
        return "Your total score is #{score} more than the required #{level}, you win!"
    else
        return "Your total score is #{score} less than the required #{level}, you lose!"
    end
end


def play_game
    
    # get name
    get_name = "What is your name? "
    name = get_response(get_name)
    
    # get level of difficulty
    get_level = "Hello #{name}, choose play level (points to win): 1 for Easy (10pts), 2 for Medium (20pts), 3 for Difficult (40pts) "
    while play_level = get_response(get_level).to_i
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
    puts shuffled_word = shuffle_word(word_to_play)
    i = 1
    while i < 4
        word_input = get_word_input(i)


        puts rep1 = is_word(word_input)
        puts rep2 = check_word(word_to_play, word_input)
       

        # if rep1.include?("Error") || rep2.include?("Error")# check if invlid
        #     # puts shuffled_word
        #     word_input = get_word_input(i)
        # else
        #     next
        # end
        i += 1
    end
    
    # total_score = get_score
    # puts results(total_score, score_threshold)
end


# word_input
# play_game








