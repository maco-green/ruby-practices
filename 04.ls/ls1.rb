#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

def read_files
  Dir.glob('*').sort
end

def main
  files = read_files
  return if files.empty?

  if ARGV.include?('-l')
    l_format(files)
  else
    normal_format(files)
  end
end

def permission_string(perm)
  (perm & 4 != 0 ? 'r' : '-') +
    (perm & 2 != 0 ? 'w' : '-') +
    (perm & 1 != 0 ? 'x' : '-')
end

def max_filename_length(files)
  files.map(&:length).max
end

def l_format(files)
  total = files.map { |name| File.stat(name).blocks }.sum
  puts "total #{total}"

  max_length = max_filename_length(files)

  files.each do |name|
    stat = File.stat(name)
    type = stat.directory? ? 'd' : '-'

    digits = stat.mode.to_s(8)[-3, 3].chars.map(&:to_i)
    perms = digits.map { |d| permission_string(d) }
    mode = perms.join

    nlink = stat.nlink.to_s.rjust(2)
    owner = Etc.getpwuid(stat.uid).name.ljust(10)
    group = Etc.getgrgid(stat.gid).name.ljust(6)
    size = stat.size.to_s.rjust(4)
    mtime = stat.mtime.strftime('%_m %e %H:%M')

    puts "#{type}#{mode} #{nlink} #{owner} #{group} #{size}  #{mtime} #{name.ljust(max_length)}"
  end
end

COLUMNS = 3

def normal_format(files)
  max_length = max_filename_length(files)
  rows = (files.size.to_f / COLUMNS).ceil

  matrix = to_matrix(files, rows)
  print_matrix(matrix, max_length)
end

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

def print_matrix(matrix, max_length)
  matrix.each do |row|
    row.each do |file|
      print file.ljust(max_length + 2) if file
    end
    puts
  end
end

main
