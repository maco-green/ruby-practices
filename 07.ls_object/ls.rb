# frozen_string_literal: true

require 'optparse'
require_relative 'file_info'
require_relative 'ls_command'

options = ARGV.getopts('arl')

show_all = options['a']
reverse_mode = options['r']
long_format = options['l']

ls_command = LsCommand.new(show_all:, reverse_mode:, long_format:)

ls_command.main
