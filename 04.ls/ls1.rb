#!/usr/bin/env ruby
# frozen_string_literal: true

files = Dir.entries('.').reject { |file| file.start_with?('.') }.sort

return if files.empty?

COLUMN = 3

lengths = files.map(&:length)

max_length = lengths.max

total_files = files.length

lines = (total_files.to_f / COLUMN).ceil

def format_data(files, lines)
  columns = files.each_slice(lines).to_a

  max_size = columns.map(&:size).max || 0

  columns.each do |column_array|
    (max_size - column_array.size).times do
      column_array << nil
    end
  end

  columns.transpose
end

display_data = format_data(files, lines)

def print_data(display_data, max_length)
  display_data.each do |line_data|
    line_data.each do |file|
      printf("%-#{max_length}s  ", file) if file
    end
    puts
  end
end

print_data(display_data, max_length)
