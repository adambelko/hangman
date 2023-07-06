require "yaml"
require "./text_content"

class Game
  attr_accessor :secret_word, :representation, :matched_letters, :unmatched_letters, :counter

  include TextContent

  def initialize
    @secret_word = random_word
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
    saved_files = Dir.glob("./saved_games/*.yml")
    puts "No saved games found." if !File.directory?("./saved_games") || saved_files.empty?
    return Game.new.start_game if !File.directory?("./saved_games") || saved_files.empty?

    puts
    puts "Which game would you like to load?"

    saved_files.each_with_index do |file, index|
      file_name = File.basename(file, ".yml")
      puts "##{index + 1}: #{file_name}"
    end

    selection = gets.chomp.to_i

    if selection.between?(1, saved_files.length)
      file_path = saved_files[selection - 1]
      loaded_data = Psych.safe_load_file(file_path, permitted_classes: [Game])
      game = loaded_data.first
      self.secret_word = game.secret_word
      self.representation = game.representation
      self.matched_letters = game.matched_letters
      self.unmatched_letters = game.unmatched_letters
      self.counter = game.counter

      file_name = File.basename(file_path, ".yml")
      puts display_load_game(file_name, representation.join(" "))
      game_loop
    else
      puts display_invalid_input
      load_game
    end
  end

  def save_game
    puts display_write_file_name
    file_name = take_input_file_name
    puts display_saved_game_info(file_name)

    Dir.mkdir("./saved_games") unless File.directory?("./saved_games")
    File.open("./saved_games/#{file_name}.yml", "w") { |f| YAML.dump([] << self, f) }
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

  def take_input_file_name
    input = gets.chomp
    return input.downcase.gsub(" ", "_") if file_name_valid?(input)

    puts display_invalid_input
    take_input_file_name
  end

  def file_name_valid?(input)
    /\A(?:[a-zA-Z][a-zA-Z0-9 ]*)?\z/.match?(input)
  end

  def valid_input?(input)
    input.downcase == "save" || /^[[:alpha:]]+$/.match?(input) && input.length == 1 ? true : false
  end

  def start_game_valid_input?
    input = gets.chomp
    return input if %w[1 2].include?(input)

    puts display_invalid_input_start_game
    start_game_valid_input?
  end
end

Game.new.start_game
