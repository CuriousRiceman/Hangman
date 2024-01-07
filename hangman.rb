require 'json'

class Hangman
  def initialize
    @guesses = 10
    @save_game = false
    @load_saved_game = nil
    @word_to_guess = randomly_selected_between_five_and_twelve(load_dictionary("google-10000-english.txt"))
    @array_to_match = @word_to_guess.chars
    @array_to_display_their_guess = Array.new(@word_to_guess.length, "_")
  end

  def load_dictionary(file_name)
    File.readlines(file_name, chomp: true)
  end

  def randomly_selected_between_five_and_twelve(selected_dictionary)
    filter = selected_dictionary.select { |word| word.length.between?(5, 12) }
    filter.sample
  end

  def save_game
    puts "Saving game..."
    game_state = {
      guesses: @guesses,
      word_to_guess: @word_to_guess,
      array_to_match: @array_to_match,
      array_to_display_their_guess: @array_to_display_their_guess
    }
    File.write("saved_game.json", JSON.generate(game_state))
  end

  def load_game
    if File.exist?("saved_game.json")
      puts "Do you want to load the saved game? (yes/no)"
      answer = gets.chomp.downcase
      if answer == "yes"
        saved_game = JSON.parse(File.read("saved_game.json"))
        @guesses = saved_game['guesses']
        @word_to_guess = saved_game['word_to_guess']
        @array_to_match = saved_game['array_to_match']
        @array_to_display_their_guess = saved_game['array_to_display_their_guess']
        puts "Game loaded successfully!"
        return
      end
    end
    puts "Starting a new game..."
    initialize
  end

  def find_indices_of_letter(letter)
    indices = []
    @array_to_match.each_with_index do |char, index|
      indices << index if char == letter
    end
    indices
  end

  def guess
    puts "Hangman: #{@array_to_display_their_guess.join(' ')}"
    puts "If you want to save the game at any point, simply enter 'save'. "
    puts @word_to_guess
    while @guesses.positive?
      puts "Enter a letter: "
      letter = gets.chomp.downcase

      if letter == 'save'
        save_game
        puts 'Game saved successfully!'
        break
      elsif letter.length != 1 || !letter.match?(/[a-z]/)
        puts 'Please enter a valid single letter.'
        next
      end

      indices = find_indices_of_letter(letter)
      if indices.any?
        indices.each { |index| @array_to_display_their_guess[index] = letter }
        puts "Hangman: #{@array_to_display_their_guess.join(' ')}"
        solved = @array_to_match == @array_to_display_their_guess
        if solved
            puts 'You guessed the word correctly!'
            break
        end
      else
        @guesses -= 1
        puts "Entered a wrong letter. #{@guesses} left. "
        puts " "
      end
    end

    puts 'Game over. You ran out of guesses.' if @guesses.zero?
  end
end

hangman = Hangman.new
hangman.load_game
hangman.guess
