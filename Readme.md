## Source code:

https://github.com/lingyenlee/Ruby_Word_Game

## Software Development Plan

# Brief desciption of application
This is a word game app. The player is presented with a randomly-scrambled 10-letter word. Each letter (A-Z ) has points. The goal of the game is to allow the player to make valid words from the letters in the shuffled word and score as many points as possible from each word formed. To win the game, the player has to score equal or higher than the difficulty level chosen. There are 3 levels of difficulty, with increasing number of points needed to win.

# Motivation
Learning English words can be difficult or boring if you read from the dictionary. The app aims to make the learning more interesting. Its goals is increase the word vocabulary and spelling power of an individual.

# Target audience
Anyone who wants to learn Engish or just have fun! The game has 3 difficulty levels so player can choose according to his/her ability. 

# How to use it
Navigate into the folder containing the file word_game.rb. Start the game by typing in "ruby word_game.rb" (without the quotation). The game starts when it ask for player's name, then allows the player to choose the level of difficulty. Once the level is selected, the player is presented with a randomly selected 10-letter scrambled word and prompt for word input. When the player enters a word, checks will be made on the word including
-if it exists (matched against an online dictionary WORDSAPI)
-if the correct letters and numbers of letters are present in the shuffled word
Player will be prompt to re-enter another word if the input word does not pass these checks. If the input word is valid, the current word score and the running total will be calculated and displayed to the player. After 3 inputs, the game will return the total score. If the score is equal or over the score threshold of the selected level, the player wins. Otherwise, the player loses. At the end of the game, the player chooses either to continue or exit game.
 
## List of features in the app

# Feature 1: level_menu(name)
This feature uses the gem tty-select and takes one parameter (name of player entered). It displays the menu to allow player to choose level of difficulty. When the player selects a level, the response is saved to a variable called play_level. Also creates a hash that maps play level to score threshold. Returns score threshold values 

# Feature 2: Validate word
This feature makes query of the word input from WORDSAPI. Returns JSON and is parsed to a hash and saved to "my_resp". If the word exists, it will return the true boolean, otherwise return the false boolean. The counts of each letter in the given word and the input word saved to 2 separate hashes. Each letter in the word input hash is compared the given word hash. The word is valid if it meets 2 conditions: (1)letters used are present and (2)not greater than those appear in the given word. The difference in the 2 hashes is save to an array called diff and is the returned value. Finally the word is validated using the method validate_word which takes in 4 parameters:
-word: the returned boolean value of get_word
-letter: the returned array (diff) of check_letter
-input: word input of player 
-saved_input: a hash created and saved all word input 

Four conditions must be met for the word input to be valid:
-must have at least 2 characters
-word exists using Feature 2
-letters used are present and not more using Feature 3
-word input is not duplicated (by comparing to saved_input hash)
The feature returns warning messages if the conditions are not met and return a boolean true value if the word is valid.

# Feature 3: Calculate word and total score
2 methods are created to calcuate the scores. The first method, get_word_score takes in 3 parameters and sums the scores of letters in the word and keep tracks of running scores
-input: word input of player
-score: the initialized total score
-threshold: the score threshold value needed to win the game
The second method methods called results display the total score at the end of the game and indicates if the player has won or lost. It takes in 2 parameters:
-score which is the total score at the end of game
-level which is the score threshold needed to get over to win
-the original word to display

# Feature 4: Main menu
This feature uses the gem tty-select andshows the main menu with 4 options to help player to navigate in the game. The 1st option shows the game information. The 2nd option shows the points for letters. The 3rd option starts the game. The 4th option exits the game. No error handling needed.


# Outline - user interaction and experience
The app starts with displaying the a welcome message and asking for user's name. An input is required. If the user press enter without entering, a warning message appears. After the user has provided a name, the user will be addressed by the name and is present a menu with 4 options to choose from. The user can use the up and down arrows to select the options, which is highlighted where the arrow points.
If option 1 is chosen, the user is shown the information about the game. The user is instructed to return to main menu by pressing spacebar. 
If option 2 is chosen, the user is shown the letter score table and exit by pressing the spacebar.
If option 3 is chosen, a menu with difficulty levels is presented and player can chose the level by moving up and down key. When a level is chosen, the shuffled word is given. The player will have 4 tries to make a word. After each input, the word score and running total is provided as well as number of points needed to win if not reached threshold. At the 4th input, the original word is revealed and final score is given and whether the player has won or lost the game. The player is asked whether to continue playing. If the player press no, it will return to main menu. The player can then exit by choosing option 4.

# Error handling
-Name input is required. Pressing spacebar will lead to warning message "Value must be provided"
-During word input, warning feedback will be given to the player if the following is performed -- 1) if the player enters only 1 character, 2) if the word entered does not exist 3) if the letter input enter is not found in the word, 4)if the same letters in the input are more than those in the word.

## HELP - Getting Started 
# How to use and install application
1.Download or clone the folder from https://github.com/lingyenlee/Ruby_Word_Game.git

2.Get a API key from https://www.wordsapi.com/

3.Create 2 files file named ".env" and .gitignore in the same folder as the downloaded folder. 

4.In the .env file, add your API key as follow:
`PROJECT_API_KEY=Your API Key`

5.In the .gitignore file, add the following code"
`.env`

6.Install the required gems below
'uri', 'openssl', 'httparty', 'json', 'dotenv', 'tty-prompt', 'colorize', 'tty-box','tty-font','terminal-table', 'pastel'

7.cd to the directory containing all the files if not in it.

8.In the terminal, start the app by running 'ruby word_game.rb'.

9.The app can be run on Windows or Mac.









