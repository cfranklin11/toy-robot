# frozen_string_literal: true

require 'pty'
require 'spec_helper'
require './app/interfaces/cli'

describe CLI do
  describe '#start' do
    it 'prompts the user to place the robot' do
      PTY.spawn('ruby toy_robot.rb') do |output, _input|
        expect(output.readline).to include(CLI::COMMAND_PROMPT)
      end
    end

    it 'includes all available commands as options' do
      PTY.spawn('ruby toy_robot.rb') do |output, input|
        # Skip the prompt
        output.readline
        # PTY hangs when trying to read the final line of the prompt, so we add a blank one
        input.puts ''

        CLI::COMMANDS.each do |command|
          expect(output.readline).to include(command)
        end
      end
    end
  end
end
