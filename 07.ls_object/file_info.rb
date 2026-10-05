# frozen_string_literal: true

require 'etc'

class FileInfo
  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
    @stat = File.stat(file_name)
  end

  def blocks
    @stat.blocks
  end

  def file_mode
    digits = @stat.mode.to_s(8)[-3, 3].chars.map(&:to_i)
    perms = digits.map { |d| permission_string(d) }.join
    (directory? ? 'd' : '-') + perms
  end

  def nlink
    @stat.nlink
  end

  def owner_name
    Etc.getpwuid(@stat.uid).name
  end

  def group_name
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime
  end

  private

  def directory?
    @stat.directory?
  end

  def permission_string(perm)
    [[4, 'r'], [2, 'w'], [1, 'x']].map { |num, char| perm & num != 0 ? char : '-' }.join
  end
end
