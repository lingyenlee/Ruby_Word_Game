
# randomly chose a word from array and shuffle it
def shuffle_word()

    words = ["absolutely","collection", "applicants", "consolidate", "government", "impossible",
    "generation", "frequently", "recognized", "restaurant", "philosophy", "adjustment", "affordable",
    "phenomenal", "acquiesced", "accustomed", "adenovirus", "basophilic", "catalogues", "dehumidify"]
    
    selected_words = []
   
    # randomly select a word and save to an array
    random = words.sample
    selected_words.push(random)
    
     # shuffle the letters and save to the same array
    shuffled_word = random.split("").shuffle.join("")
    selected_words.push(shuffled_word)

    # return the saved array
    return selected_words
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
