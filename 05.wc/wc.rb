# frozen_string_literal: true

require 'optparse'

def count_text(text, name = '')
  lines = text.count("\n")
  words = text.split.size
  bytes = text.bytesize
  { name: name, lines: lines, words: words, bytes: bytes }
end

def format_record(rec, show_l:, show_w:, show_c:)
  cols = []
  cols << rec[:lines].to_s.rjust(8) if show_l
  cols << rec[:words].to_s.rjust(8) if show_w
  cols << rec[:bytes].to_s.rjust(8) if show_c
  cols << rec[:name]
  cols.join(' ')
end

opts = ARGV.getopts('lwc')
any_option = opts.values.any?
show_l = opts['l'] || !any_option
show_w = opts['w'] || !any_option
show_c = opts['c'] || !any_option

file_names = ARGV.reject { |arg| arg.start_with?('-') }

if file_names.empty?
  text = $stdin.read
  results = [count_text(text)]
else
  results = file_names.map { |fn| count_text(File.read(fn), fn) }

  if file_names.size >= 2
    totals = {
      name: 'total',
      lines: results.sum { |r| r[:lines] },
      words: results.sum { |r| r[:words] },
      bytes: results.sum { |r| r[:bytes] }
    }

    results << totals
  end
end

results.each do |rec|
  puts format_record(rec, show_l: show_l, show_w: show_w, show_c: show_c)
end
