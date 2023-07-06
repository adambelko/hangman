require "yaml"
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
    puts display_intro
    option = start_game_valid_input?
    option == "1" ? new_game : load_game
  end

  private

  def new_game
    puts display_new_game(secret_word.length, counter)
    game_loop
  end

  def load_game
    loaded_data = Psych.safe_load_file("./test.yml", permitted_classes: [Game])
    game = loaded_data.first
    self.secret_word = game.secret_word
    self.representation = game.representation
    self.matched_letters = game.matched_letters
    self.unmatched_letters = game.unmatched_letters
    self.counter = game.counter

    p loaded_data
    puts display_load_game
    puts "Secret word: #{representation.join(" ")}"
    game_loop
  end

  def save_game
    File.open("./test.yml", "w") { |f| YAML.dump([] << self, f) }
    puts
    puts "Game saved"
    Game.new.start_game
  end

  def game_loop
    return puts display_game_win(secret_word) if representation.join("") == secret_word
    return puts display_game_over(secret_word) if counter.zero?

    puts display_turn(counter)
    input = take_input
    return save_game if input == "save"

    letter = input
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
      puts display_letter_used_already
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
    input == "save" || /^[[:alpha:]]+$/.match?(input) && input.length == 1 ? true : false
  end

  def start_game_valid_input?
    input = gets.chomp
    return input if %w[1 2].include?(input)

    puts display_invalid_input_start_game
    start_game_valid_input?
  end
end

Game.new.start_game
