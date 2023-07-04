require "./text_content"

class Game
  attr_accessor :secret_word, :representation, :matched_letters, :unmatched_letters, :counter

  include TextContent

  def initialize
    # @secret_word = random_word
    @secret_word = "table"
    @representation = Array.new(secret_word.length, "_")
    @matched_letters = []
    @counter = 10
  end

  def start_game
    puts display_intro(secret_word.length)
    puts display_turn(counter)
    letter = take_input
    matched_letter?(letter)
    display_representation
  end

  private

  def display_representation
    word = secret_word.split("")

    matched_indexes = word.each_index.select { |index| matched_letters.include?(word[index]) }

    matched_indexes.each do |index|
      representation[index] = word[index]
    end

    p representation.join(" ")
  end

  def matched_letter?(letter)
    if secret_word.include?(letter)
      matched_letters << letter
    else
      puts "No match this time :("
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
    /^[[:alpha:]]+$/.match?(input)
  end
end

Game.new.start_game
