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

# Feature 1 - Get 

This 
# Count word and total score
A dictionary 