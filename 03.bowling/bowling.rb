#!/usr/bin/env ruby
# frozen_string_literal: true

TOTAL_PINS = 10
score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  if s == 'X'
    shots << TOTAL_PINS
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = 0

frames.first(9).each_with_index do |frame, index|
  bonus = 0

  if frame[0] == TOTAL_PINS
    next_frame = frames[index + 1]

    if next_frame[0] == TOTAL_PINS
      next_next_frame = frames[index + 2]
      bonus = next_frame[0] + next_next_frame[0]
    else
      bonus = next_frame.sum
    end

  elsif frame.sum == TOTAL_PINS
    bonus = frames[index + 1][0]
  end

  point += frame.sum + bonus
end

point += frames[9..].flatten.sum if frames[9..]

puts point
