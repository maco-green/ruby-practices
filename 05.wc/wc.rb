# frozen_string_literal: true

require 'optparse'

def count_text(text, name = '')
  lines = text.count("\n")
  words = text.split.size
  bytes = text.bytesize
  { name:, lines:, words:, bytes: }
end

def format_record(rec, show:)
  cols = []

  show.each do |key, visible|
    cols << rec[key].to_s.rjust(8) if visible
  end

  cols << rec[:name]
  cols.join(' ')
end

opts = { lines: false, words: false, bytes: false }

OptionParser.new do |parser|
  parser.on('-l') { opts[:lines] = true }
  parser.on('-w') { opts[:words] = true }
  parser.on('-c') { opts[:bytes] = true }
end.parse!(ARGV)

if opts.values.none?
  opts[:lines] = true
  opts[:words] = true
  opts[:bytes] = true
end

file_names = ARGV

if file_names.empty?
  text = $stdin.read
  results = [count_text(text)]
else
  results = file_names.map { count_text(File.read(it), it) }

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
  puts format_record(rec, show: opts)
end
