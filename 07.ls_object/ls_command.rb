# frozen_string_literal: true

class LsCommand
  COLUMNS = 3

  def initialize(show_all:, reverse_mode:, long_format:)
    @show_all = show_all
    @reverse_mode = reverse_mode
    @long_format = long_format
  end

  def main
    files = read_files
    files = files.map { |file| FileInfo.new(file) }
    files = files.reverse if @reverse_mode
    return if files.empty?

    if @long_format
      print_long_format(files)
    else
      print_column_format(files)
    end
  end

  private

  def read_files
    Dir.glob('*', @show_all ? File::FNM_DOTMATCH : 0).sort
  end

  def max_filename_length(files)
    files.map { |file| file.file_name.length }.max
  end

  def print_long_format(files)
    total = files.map(&:blocks).sum
    puts "total #{total}"

    max_length = max_filename_length(files)

    files.each do |file|
      puts [
        file.file_mode,
        file.nlink.to_s.rjust(2),
        file.owner_name.ljust(10),
        file.group_name.ljust(6),
        file.size.to_s.rjust(4),
        file.mtime.strftime('%_m %e %H:%M'),
        file.file_name.ljust(max_length)
      ].join(' ')
    end
  end

  def print_column_format(files)
    max_length = max_filename_length(files)
    rows = files.size.ceildiv(COLUMNS)

    matrix = to_matrix(files, rows)
    print_matrix(matrix, max_length)
  end

  def print_matrix(matrix, max_length)
    matrix.each do |row|
      row.each do |file|
        print file.file_name.ljust(max_length + 2) if file
      end
      puts
    end
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
end
