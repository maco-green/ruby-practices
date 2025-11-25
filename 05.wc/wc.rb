# frozen_string_literal: true

require 'optparse'

def count_text(text, name = '')
  lines = text.count("\n")
  words = text.split.size
  bytes = text.bytesize
  { name:, lines:, words:, bytes: }
end

def format_record(rec, show_l:, show_w:, show_c:)
  cols = []
  cols << rec[:lines].to_s.rjust(8) if show_l
  cols << rec[:words].to_s.rjust(8) if show_w
  cols << rec[:bytes].to_s.rjust(8) if show_c
  cols << rec[:name]
  cols.join(' ')
end

opts = { 'l' => false, 'w' => false, 'c' => false }
OptionParser.new do |parser|
  parser.on('-l') { opts['l'] = true }
  parser.on('-w') { opts['w'] = true }
  parser.on('-c') { opts['c'] = true }
end.parse!(ARGV)

if opts.values.none?
  opts['l'] = true
  opts['w'] = true
  opts['c'] = true
end

file_names = ARGV

if file_names.empty?
  text = $stdin.read
  results = [count_text(text)]
else
  results = file_names.map { |it| count_text(File.read(it), it) }

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
  puts format_record(rec, show_l: opts['l'], show_w: opts['w'], show_c: opts['c'])
end
