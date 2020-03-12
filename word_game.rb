#! /usr/bin/env ruby

# require gems for making api
require 'uri'
require 'openssl'
require 'net/https'
require 'httparty' 
require 'json'

# require gems for others
require 'tty-prompt'
require 'colorize'
require 'tty-box'
require 'tty-font'


# randomly shuffle word
def shuffle_word(word)
    arr = word.split("").shuffle
     # randomly shuffle the letters
    shuffled_word = arr.join("")
    return shuffled_word
end

# make hash to track elements in array
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
def get_word(input)
   
    # response = nil
    url = URI("https://wordsapiv1.p.rapidapi.com/words/#{input}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(url) 
    request["x-rapidapi-host"] = 'wordsapiv1.p.rapidapi.com'
    request["x-rapidapi-key"] = '1b2c49a91bmshddce31cebd15864p1a6966jsn68d6321288f9' #api key
    
    response = http.request(request) #save req to resonse
    # puts response.body
    my_resp = JSON.parse(response.body) #parse json response to hash
    # puts my_resp.class

    if my_resp["word"] == input #return true if word exist
        return true
    else 
        return false
    end
end

# get_word("told")
def check_letter(shuffled, input)

    # make hash and store letter count
    shuffled_hash = make_hash(shuffled.split(""))
    input_hash = make_hash(input.split(""))
    diff = []

    # compare shuffled word and input word to check if letters exist or extra letters
    input_hash.each do |k, v|
        if shuffled_hash.has_key?(k) && v > shuffled_hash[k] #more letters than in shuffled
            diff.push(k)
        elsif !shuffled_hash.has_key?(k) #letter not found in shuffled
            diff.push(k)
        else
            next
        end
    end
    return diff
end

# Validate word input - return response for word and letter checks
def validate_word(word, letter, input, saved_input)
    if input.length < 2
        puts "Too short. Need at least 2 characters.".colorize(:red)
    elsif !word
        puts "Invalid entry.".colorize(:red)
    elsif letter.length > 0 
        puts "Letter(s) not found or more than in word.".colorize(:red)
    elsif saved_input[input] > 1
        puts "Word has been used.".colorize(:red)
    else
        puts "Valid word.".colorize(:blue)
        return true
    end
end

# count word score
def get_word_score(input, score, threshold)

    # scores for each letter
    score_key = {
        "a" => 1, "b" => 3, "c" => 3, "d" => 2, "e" => 1, "f" => 4, "g" => 2, "h" => 4, "i" => 1, 
        "j" => 8, "k" => 5, "l" => 1, "m" => 3, "n" => 1, "o" => 1, "p" => 3, "q" => 10, "r" => 1, 
        "s" => 1, "t" => 1, "u" => 1, "v" => 4, "w" => 4, "x" => 8, "y" => 4, "z" => 10 }

    # initialize total score and input number
    word_score = 0
 
    # map through each letter in word and count score
    input.chars {|x| word_score += score_key[x]}
    puts "Your word score is #{word_score}."
    
    # add up total score
    total_score = score + word_score 
    puts "Total score is #{total_score}."

    # feedback score to player
    if threshold > total_score
        puts "You need #{threshold-total_score} more points to win. Keep it up!"
    elsif threshold == total_score
        puts "You have reached the score required to win!"
    else
        puts "You have scored extra #{total_score-threshold} points!"
    end

    return total_score 
end

# get results
def results(score, level)
    # feedback final score to player
    if score >= level
        return "Your total score is #{score}, higher than #{level} points needed, you win!".colorize(:color => :yellow, :background => :blue)
    else
        return "Your total score is #{score} lower than #{level} points needed, sorry you didn't win! Try harder next time!".colorize(:color => :yellow,:background => :red)
    end
end

# display difficulty menu
def level_menu(name)
    prompt = TTY::Prompt.new # use tty-prompt

     # display menu of play levels
     play_level = prompt.select("Hello #{name}, choose play level") do |level|
        level.default 1
    
        level.choice "Easy (20 pts to win)", 1
        level.choice "Medium (30 pts to win)", 2
        level.choice "Hard (45 pts to win)", 3
    end

    # map play levels to score threshold
    threshold = {1=>20, 2=>30, 3=>45}
    
    # return threshold values
    return threshold[play_level]
end

# welcome message
def welcome_message
    prompt = TTY::Prompt.new # use tty-prompt
    font = TTY::Font.new(:doom) #use tty-font
    pastel = Pastel.new #use color on tty-font

    # puts out welcome message
    puts pastel.yellow(font.write("WELCOME TO", letter_spacing: 1))
    puts pastel.yellow(font.write("THE WORD GAME", letter_spacing: 1))

    box = TTY::Box.frame(width: 50, height: 10, align: :center, border: :thick) do
    "This is a word game. The goal of the game is to make words from a 10-letter word
and score as many as points for the level of difficulty chosen. There are 3 levels\n
of difficulty. In order to win, you have to score more than 10 points for the Easy\n
level, 20 points for Medium level and 40 points for the Hard level. You will have 3\n
inputs to make a new word.\n"
    end
    print box
end


def play_game

    prompt = TTY::Prompt.new # use tty-prompt

    # display welcome message
    welcome_message

     # get name
    name = prompt.ask("What is your name?")
    
    while true

        # get play level and score threshold
        score_threshold = level_menu(name)
         
        # present shuffle word
        word_to_play = "consolidate"
        shuffled_word = shuffle_word(word_to_play)
        puts "Your word is #{shuffled_word}."
        
        # initialize values
        arr = []
        i = 1
        total_score = 0

        while i < 5
        
            # get word input and save to an array and make a hash to keep trash
            if i == 1
                word_input = prompt.ask("You have #{5-i} input. Make a word from #{shuffled_word}")
            else
                word_input = prompt.ask("You have #{5-i} input left. Make a word from #{shuffled_word}")
            end
            # save word to array and hash counter
            arr.push(word_input)
            track_word_input = make_hash(arr)
        
            # get return value of word and letter checks 
            check_word = get_word(word_input)
            check_letter = check_letter(shuffled_word, word_input)
        
            # check for invalid inputs
            validated = validate_word(check_word, check_letter, word_input, track_word_input)

            # get word score and total score
            if validated
                total_score = get_word_score(word_input, total_score, score_threshold)
            end
            i += 1
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

# puts 1.class

# prompt = TTY::Prompt.new # use tty-prompt
# word_input = prompt.ask("Make a word from ")
# puts word_input.class