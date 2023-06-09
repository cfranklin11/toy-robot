# frozen_string_literal: true

require 'tty-prompt'
require './app/controllers/robots_controller'

# Available commands for the toy_robot CLI
class CLI
  COMMAND_PROMPT = 'Select a command to send to the robot'
  PLACE_PROMPT = 'Where on the board do you want to place the robot? (format: X,Y,DIRECTION)'
  PLACE_COMMAND = 'PLACE'
  QUIT_COMMAND = 'QUIT'
  REPORT_COMMAND = 'REPORT'
  MOVE_COMMAND = 'MOVE'
  LEFT_COMMAND = 'LEFT'
  RIGHT_COMMAND = 'RIGHT'
  COMMANDS = [PLACE_COMMAND, MOVE_COMMAND, LEFT_COMMAND, RIGHT_COMMAND, REPORT_COMMAND, QUIT_COMMAND].freeze

  def initialize
    @prompt = TTY::Prompt.new
  end

  def start_game
    _prompt_command_input(COMMANDS)
  end

  private

  def _prompt_command_input(commands)
    _prompt
      .select(COMMAND_PROMPT, commands)
      .then(&method(:_handle_command))
      .tap(&method(:_display_output))
      .then { |output| _handle_output(commands, output) }
  end

  def _prompt
    @prompt
  end

  # This method is just a case statement that delegates commands to the relevant controller actions,
  # so I'm okay with its line length running over the limit.
  def _handle_command(input) # rubocop:disable Metrics/MethodLength
    case input
    when QUIT_COMMAND
      ::RobotsController.quit
    when PLACE_COMMAND
      _prompt.ask(PLACE_PROMPT).then(&::RobotsController.method(:place))
    when REPORT_COMMAND
      ::RobotsController.report
    when MOVE_COMMAND
      ::RobotsController.move
    when LEFT_COMMAND
      ::RobotsController.left
    when RIGHT_COMMAND
      ::RobotsController.right
    end
  end

  def _display_output(output)
    puts "\n#{output.fetch(:message)}\n\n"
  end

  def _handle_output(prev_commands, output)
    case output.fetch(:result)
    when :failure
      _prompt_command_input(prev_commands)
    when :success
      _prompt_command_input(COMMANDS)
    when :quit
      nil
    end
  end
end
