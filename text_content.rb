# frozen_string_literal: true

module TextContent
  def display_intro(secret_word)
    <<~HEREDOC

      Secret word has been selected and it's #{secret_word} letters long.
      You have 10 incorrect guesses to solve it. Good Luck!
    HEREDOC
  end

  def display_invalid_input
    <<~HEREDOC
      \e[31mInvalid character. Please Try again.\e[0m
    HEREDOC
  end

  def display_double_letter
    <<~HEREDOC
      \e[31mYou used this letter already.\e[0m
    HEREDOC
  end

  def display_turn(counter)
    <<~HEREDOC

      #{counter} attempts left. Enter the letter.
    HEREDOC
  end

  def display_no_match
    <<~HEREDOC

      No match this time :(#{" "}

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

      The secret word is #{secret_word}

    HEREDOC
  end

  def display_game_win(secret_word)
    <<~HEREDOC

      \e[32m#Well done! You solved the word!\e[0m
      \e[32m#The secret word is "#{secret_word}".\e[0m

    HEREDOC
  end
end
