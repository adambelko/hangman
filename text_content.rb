# frozen_string_literal: true

require "./display"

module TextContent
  def display_intro(secret_word)
    <<~HEREDOC

      Secret word has been selected and it's #{secret_word} letters long.
      You have 10 turns to solve it. Good Luck!
    HEREDOC
  end

  def display_invalid_input
    <<~HEREDOC
      \e[31mInvalid character. Please Try again.\e[0m
    HEREDOC
  end

  def display_turn(counter)
    <<~HEREDOC

      Turn ##{counter}: Enter the letter.
    HEREDOC
  end
end
