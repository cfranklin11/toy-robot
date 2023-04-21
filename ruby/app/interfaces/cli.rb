# frozen_string_literal: true

require 'tty-prompt'
require './app/controllers/robots_controller'

# Available commands for the toy_robot CLI
class CLI
  COMMAND_PROMPT = 'Select a command to send to the robot'
  PLACE_PROMPT = 'Where on the board do you want to place the robot? (format: X,Y,DIRECTION)'
  PLACE_COMMAND = 'PLACE'
  QUIT_COMMAND = 'QUIT'
  COMMANDS = [PLACE_COMMAND, QUIT_COMMAND].freeze

  def initialize
    @prompt = TTY::Prompt.new
  end

  def start_game
    _prompt_command_input
  end

  private

  def _prompt_command_input
    _prompt
      .select(COMMAND_PROMPT, COMMANDS)
      .then(&method(:_handle_command))
      .tap(&method(:_display_output))
      .then(&method(:_handle_output))
  end

  def _prompt
    @prompt
  end

  def _handle_command(input)
    case input
    when QUIT_COMMAND
      ::RobotsController.new(input).quit
    when PLACE_COMMAND
      _prompt
        .ask(PLACE_PROMPT)
        .then { |place_input| ::RobotsController.new(place_input) }
        .place
    end
  end

  def _display_output(output)
    puts "\n#{output}\n\n"
  end

  def _handle_output(output)
    return if output == ::RobotsController::QUIT_MESSAGE

    _prompt_command_input
  end
end
