# frozen_string_literal: true

module TextContent
  def display_intro
    <<~HEREDOC

      Welcome to the game Hangman!
      Type "1" for a new game.
      Type "2" to load a game.

    HEREDOC
  end

  def display_new_game(secret_word, counter)
    <<~HEREDOC

      Secret word has been selected and it's #{secret_word} letters long.
      You have #{counter} incorrect guesses to solve it. Good Luck!
    HEREDOC
  end

  def display_load_game(file_name, representation)
    <<~HEREDOC

      "#{file_name}" game has been loaded.
      Secret word is: #{representation}
    HEREDOC
  end

  def display_write_file_name
    <<~HEREDOC

      Type the name of a file you want to save this game to.
    HEREDOC
  end

  def display_saved_game_info(file_name)
    <<~HEREDOC

      You saved the game as #{file_name}.yml
      Remember this so you can load it later on.
    HEREDOC
  end

  def display_invalid_input
    <<~HEREDOC
      \e[31mInvalid input. Please Try again.\e[0m
    HEREDOC
  end

  def display_invalid_input_start_game
    <<~HEREDOC
      \e[31mInvalid input. Please select between option 1 and 2.\e[0m
    HEREDOC
  end

  def display_letter_used_already
    <<~HEREDOC
      \e[31mYou used this letter already.\e[0m
    HEREDOC
  end

  def display_turn(counter)
    <<~HEREDOC

      #{counter} attempts left. Enter the letter or  write "save" to save the game.
    HEREDOC
  end

  def display_no_match
    <<~HEREDOC

      No match this time :(.#{" "}

    HEREDOC
  end

  def display_match
    <<~HEREDOC

      Good guess!

    HEREDOC
  end

  def display_game_over(secret_word)
    <<~HEREDOC

      \e[31mGame Over!\e[0m

      The secret word was "#{secret_word}".

    HEREDOC
  end

  def display_game_win(secret_word)
    <<~HEREDOC

      \e[32mWell done! You solved the word!\e[0m
      \e[32mThe secret word is "#{secret_word}".\e[0m

    HEREDOC
  end
end
