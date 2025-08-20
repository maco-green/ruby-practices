#!/usr/bin/env ruby
# frozen_string_literal: true

def read_files(show_all:)
  Dir.glob('*', show_all ? File::FNM_DOTMATCH : 0).sort
end

show_all = ARGV.include?('-a')
files = read_files(show_all:)

return if files.empty?

COLUMNS = 3
file_lengths = files.map(&:length)
max_length = file_lengths.max
rows = (files.size.to_f / COLUMNS).ceil

def to_matrix(file_list, row_count)
  columns = file_list.each_slice(row_count).to_a

  max_rows = columns.map(&:size).max || 0

  columns.each do |column|
    (max_rows - column.size).times do
      column << nil
    end
  end

  columns.transpose
end

matrix = to_matrix(files, rows)

def print_matrix(matrix, max_length)
  matrix.each do |row|
    row.each do |file|
      print file.ljust(max_length + 2) if file
    end
    puts
  end
end

print_matrix(matrix, max_length)
