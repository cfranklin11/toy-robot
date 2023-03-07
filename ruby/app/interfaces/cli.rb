# frozen_string_literal: true

require 'tty-prompt'

# Available commands for the toy_robot CLI
class CLI
  COMMAND_PROMPT = 'Select a command to send to the robot'
  PLACE_PROMPT = 'Where on the board do you want to place the robot? (format: X,Y,DIRECTION)'
  QUIT_MESSAGE = 'Thanks for playing Toy Robot!'
  PLACE_COMMAND = 'PLACE'
  QUIT_COMMAND = 'QUIT'
  COMMANDS = [PLACE_COMMAND, QUIT_COMMAND].freeze

  def initialize
    @prompt = TTY::Prompt.new
  end

  def start_game
    _prompt_command_input
      .then(&method(:puts))
  end

  private

  def _prompt_command_input
    _prompt
      .select(COMMAND_PROMPT, COMMANDS)
      .then(&method(:_handle_command))
  end

  def _prompt
    @prompt
  end

  def _handle_command(result)
    case result
    when QUIT_COMMAND
      QUIT_MESSAGE
    else
      _prompt_command_input
    end
  end
end
