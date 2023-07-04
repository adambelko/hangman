require "./text_content"

class Game
  attr_accessor :secret_word, :representation, :matched_letters, :unmatched_letters, :counter

  include TextContent

  def initialize
    # @secret_word = random_word
    @secret_word = "tablet"
    @representation = Array.new(secret_word.length, "_")
    @matched_letters = []
    @unmatched_letters = []
    @counter = 10
  end

  def start_game
    puts display_intro(secret_word.length)
    game_loop
  end

  private

  def game_loop
    return puts display_game_over(secret_word) if counter.zero?
    return puts display_game_win(secret_word) if representation.join("") == secret_word

    puts display_turn(counter)
    letter = take_input
    matched_letter?(letter)
    puts display_representation
    puts display_unmatched_letters
    game_loop
  end

  def display_unmatched_letters
    puts "Unmatched letters: #{unmatched_letters.join(" ")}" unless unmatched_letters.empty?
  end

  def display_representation
    word = secret_word.split("")

    matched_indexes = word.each_index.select { |index| matched_letters.include?(word[index]) }

    matched_indexes.each do |index|
      representation[index] = word[index]
    end

    "Secret word: #{representation.join(" ")}"
  end

  def matched_letter?(letter)
    if secret_word.include?(letter)
      puts display_match
      matched_letters << letter
    elsif unmatched_letters.include?(letter)
      puts display_double_letter
    else
      puts display_no_match
      unmatched_letters << letter
      self.counter -= 1
    end
  end

  def random_word
    dictionary = File.readlines("./words.txt")
    filtered_dictionary = dictionary.select { |word| word.strip.length.between?(5, 12) }
    filtered_dictionary.sample
  end

  def take_input
    input = gets.chomp
    return input.downcase if valid_input?(input)

    puts display_invalid_input
    take_input
  end

  def valid_input?(input)
    /^[[:alpha:]]+$/.match?(input) && input.length == 1 ? true : false
  end
end

Game.new.start_game
