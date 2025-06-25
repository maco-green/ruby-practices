#!/usr/bin/env ruby

require "date"
require 'optparse'

year = Date.today.year
month = Date.today.month

OptionParser.new do |option|
  option.on("-y", "--year YEAR", Integer, "Year") { |v| year = v }
  option.on("-m", "--month MONTH", Integer, "Month") { |v| month = v }
end.parse!

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)

puts "#{month}月 #{year}".center(18)
puts "日 月 火 水 木 金 土"
print "   " * first_day.wday

(first_day..last_day).each do |date|
  print date.day.to_s.rjust(2) + " "
  puts if date.saturday?
end

puts
