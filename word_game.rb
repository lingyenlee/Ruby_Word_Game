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
    shuffle_hash = make_hash(shuffle)
    input_hash = make_hash(input)
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

# def get_total(acc, current)
#     total = acc + current
#     return total
# end

# count word score
def get_word_score(word_input)

    # scores for each letter
    score_key = {
        "a" => 1, "b" => 3, "c" => 3, "d" => 2, "e" => 1, "f" => 4, "g" => 2, "h" => 4, "i" => 1, 
        "j" => 8, "k" => 5, "l" => 1, "m" => 3, "n" => 1, "o" => 1, "p" => 3, "q" => 10, "r" => 1, 
        "s" => 1, "t" => 1, "u" => 1, "v" => 4, "w" => 4, "x" => 8, "y" => 4, "z" => 10 }

    # initialize total score and input number
    word_score = 0
    # total_score = 0
 
    word_input.chars {|x| word_score += score_key[x]}
    puts "Your word score is #{word_score}."
    return word_score
  
end

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
    
    while true
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
        shuffled_word = shuffle_word(word_to_play)
        arr = []
        word_hash = {}
        i = 1
        total_score = 0
        while i < 4
            # display shuffled word
            puts shuffled_word

            # get word input and save to an array and make a hash to keep trash
            word_input = get_word_input(i)
            arr.push(word_input)
            arr.each do |i|
                if word_hash.has_key?(i)
                    word_hash[i] += 1
                else
                    word_hash[i] = 1
                end
            end
        
            # get value of checkings
            check_word = get_word(word_input)
            check_letter = check_letter(shuffled_word, word_input)
        

            if check_word && check_letter.length > 0
                puts "Letter(s) not found or too many. Try again."
                word_input 
                # i -= 1
                next
            elsif !check_word
                puts "Invalid word. Try again."
                word_input 
                # i -= 1
                next
            elsif check_letter.length > 0 
                puts "Letter(s) not found or too many. Try again."
                word_input 
                # i -= 1
                next
            elsif word_hash[word_input] > 1
                puts "Word has been used. Try again."
                word_input 
                next
            else
                puts "Valid word."
            end
            i += 1
            word_score = get_word_score(word_input)
            total_score += word_score
            puts "Total score is #{total_score}."
        end
        puts results(total_score, score_threshold)
        play_again = get_response("Do you want to play again (y/n).")
        
    end

end


# word_input
play_game