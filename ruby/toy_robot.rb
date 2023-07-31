#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require './app/interfaces/cli'

CLI.new.start_game
