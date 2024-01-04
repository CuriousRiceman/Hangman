class Hangman
    
    def initialize()
        @guesses = 10
        @save_game = false
        @load_saved_game = nil
    end

    def load_dictionary(file_name)
        File.readlines(file_name, chomp: true)
    end

    def randomly_selected_between_five_and_twelve(selected_dictionary)
        filter = selected_dictionary.select { |word| word.length.between?(5, 12) }
        filter.sample
    end

    def guess(word_to_guess)
        length_of_word = word_to_guess.length
        array_to_match = word_to_guess.chars
        array_to_display_their_guess = Array.new(length_of_word, "_")
        puts word_to_guess
        puts "If you want to save the game at any point, simply enter 'save'. "
        while true
            while true    
                puts "Enter a letter: "
                letter = gets.chomp.downcase
                if letter.length == 4 && letter == "save"
                    @save_game = true
                elsif letter.length != 1 || !letter.match?(/[a-z]/)
                    puts "Please enter a valid single letter."
                    next
                end
                break
            end
            if array_to_match.include?(letter)
                index = array_to_match.index(letter)
                array_to_display_their_guess[index] = letter
                puts "Hangman: #{array_to_display_their_guess.join(" ")}"
                solved = true
                for i in 0..length
                    if array_to_match[i] != array_to_display_their_guess[i]
                        solved_yet_or_what = false
                        break
                    end
                end
                if solved
                    puts "You guessed the word correctly! "
                end
            else
                if @guesses == 0
                    break
                end
                @guesses -= 1
                puts "Entered a wrong letter. #{@guesses} left. "
                puts " "
            end
        end
    end

    def load_game()
        #finish menu to load a saved game or not
        #work on making the saved game launch correctly
        #finish handling for saving a game (serializing)
    end


end

hangman = Hangman.new
hangman.load_game