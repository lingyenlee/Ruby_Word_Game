#! /usr/bin/env ruby

# gems 
require 'uri'
require 'openssl'
require 'net/https'
require 'httparty' 
require 'json'
require 'dotenv/load'
require 'tty-prompt'
require 'colorize'
require 'tty-box'
require 'tty-font'
require 'terminal-table'
require 'pastel'

require './helper'

# find word in dictionary
def get_word(input)

    url = URI("https://wordsapiv1.p.rapidapi.com/words/#{input}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url) 
    request["x-rapidapi-host"] = 'wordsapiv1.p.rapidapi.com'
    request["x-rapidapi-key"] = ENV['PROJECT_API_KEY'] #api key
     
    response = http.request(request) #save req to repsonse
    # puts response.body.class
    my_resp = JSON.parse(response.body) #parse json response to hash

    if my_resp["word"] == input #return true if word exist
        return true
    else 
        return false
    end
end


def check_letter(shuffled, input)

    # make hash and store letter count
    shuffled_hash = make_hash(shuffled.downcase.split(""))
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
    # return difference between word and input
    return diff
end


# Validate word input - return response for word and letter checks
def validate_word(word, letter, input, saved_input)

    # if input less than 2 chars
    if input.length < 2
        puts "Too short. Need at least 2 characters.".colorize(:red)

    # if word is not found from online dictionary
    elsif !word
        puts "Invalid entry.".colorize(:red)

    # if input not matched to word
    elsif letter.length > 0 
        puts "Letter(s) not found or more than in word.".colorize(:red)
    
    # if input is repeated
    elsif saved_input[input] > 1
        puts "Word has been used.".colorize(:red)
    
    # validate word
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

    # feedback scores to player
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
def results(score, level, word)

    pastel = Pastel.new #use tty-pastel
    notice = pastel.blue.bold.detach

    puts "The original word is " + notice.call("#{word}.")
    # display final score to player
    if score >= level
        return "Your total score is #{score}, higher than #{level} points needed, you win!".colorize(:color => :yellow, :background => :blue)
    else
        return "Your total score is #{score}, lower than #{level} points needed, sorry you didn't win! Try harder next time!".colorize(:color => :yellow,:background => :red)
    end
end

# display difficulty menu
def level_menu()
    system("clear")
    prompt = TTY::Prompt.new # use tty-prompt

    # display menu of play levels
    ask_levels = "Choose play level"
    levels = [{"Easy (15 pts to win)"=> 1}, {"Medium (25 pts to win)"=> 2}, {"Hard (35 pts to win)"=> 3}]
    play_level = prompt.select(ask_levels, levels) 

    # map play levels to score threshold
    threshold = {1=>15, 2=>25, 3=>35}
    
    # return threshold values
    return threshold[play_level]
end

# display letter scores
def letter_score()

    system("clear")
    
    table = Terminal::Table.new :title => "LETTER SCORING TABLE", :headings => ["LETTERS", "POINTS"] do |t|
    t << ["A, E, I, O, U, L, N, R, S, T", 1]
    t << :separator
    t.add_row ["D, G", 2]
    t.add_separator
    t.add_row ["B, C, M, P", 3]
    t.add_separator
    t.add_row  ["F, H, V, W, Y", 4]
    t.add_separator
    t.add_row ["K", 5]
    t.add_separator
    t.add_row ["J, X", 8]
    t.add_separator
    t.add_row ["Q, Z", 10]
    end

    puts table
    return_menu()
end

# display menu
def welcome()

    system("clear")

    prompt = TTY::Prompt.new # use tty-prompt
    font = TTY::Font.new(:doom) #use tty-font
    pastel = Pastel.new #use color on tty-font

    # puts out welcome message
    puts pastel.yellow(font.write("WELCOME TO", letter_spacing: 1))
    puts pastel.yellow(font.write("THE WORD GAME"))
    
    # get name
    user_name = prompt.ask("Hello there, what is your name?", required: true)

    # show menu
    menu(user_name.capitalize)
end

def menu(name)
    system("clear")
    prompt = TTY::Prompt.new # use tty-prompt

    user_option = nil
    while user_option != 4
        # present options menu
        greeting = "Hi #{name}, select an option below"
        options = [{"About Game"=> 1}, {"Letter Score Values"=> 2}, {"Start Game"=> 3}, {"Exit"=> 4}] #options list
        user_option = prompt.select(greeting, options) 

        # display game info
        if user_option == 1
            about_game()

        # display letter scores values
        elsif user_option == 2
            letter_score()

        # play the game
        elsif user_option == 3
            play_game()
        
        # go back to default
        else 
            user_option
        end
    end
end

# return to main menu
def return_menu()
    prompt = TTY::Prompt.new # use tty-prompt
    user_option = prompt.keypress(
        "To return to main menu press space", keys: [:space]
    )
    system("clear")
end

# describe the game
def about_game()
    system("clear")
    box = TTY::Box.frame(width: TTY::Screen.width, height: 12, align: :center, border: :thick) do
"ABOUT THIS GAME \n 
This is a word game. You are given a 10-letter word which is randomly shuffled.
Each letter has points. The goal of the game is to make any words (at least 2 
characters) from the scrambled word and score as many as points for the level 
of difficulty chosen. There are 3 levels of difficulty. In order to win, you have 
to score at least 15 points for the Easy level, 25 points for Medium level and 35 
points for the Hard level. There will be 4 inputs given. The input will be counted 
even if you enter an invalid word, so be careful and good luck!"
    end
    print box
    return_menu()
end

def play_game()

    system("clear")
    prompt = TTY::Prompt.new # use tty-prompt
    pastel = Pastel.new #use tty-pastel
    notice = pastel.blue.bold.detach

    while true
        
        # get play level and score threshold
        score_threshold = level_menu

        # present shuffle word
        words = shuffle_word()

        original_word = words[0]
        shuffled_word = words[1]
        puts "Your word is " + notice.call("#{shuffled_word}")
        
        # initialize values
        arr = []
        i = 1
        total_score = 0

        while i < 5

            # get word input and save to an array and make a hash to keep trash
            if i == 1 
                word_input = prompt.ask("You have #{5-i} input. Make a word from " + notice.call("#{shuffled_word}"), required: true)
            else
                word_input = prompt.ask("You have #{5-i} input left. Make a word from " + notice.call("#{shuffled_word}"), required: true)
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
            if validated && i <= 3
                total_score = get_word_score(word_input, total_score, score_threshold)
            end

            # ask for next input
            i += 1
        end

        # display final results
        puts results(total_score, score_threshold, original_word)
        
        # ask if player wants to play again
        play_again = prompt.yes?("Do you want to play again (y/n)?")
        if !play_again
            system("clear")
            break
        end
    end
end


welcome()
