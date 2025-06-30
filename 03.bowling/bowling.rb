#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []

shots.each_slice(2) do |s|
  frames << s
end

point = 0

frames.first(9).each_with_index do |frame, index|
  if frame[0] == 10
    next_frame = frames[index + 1]
    if next_frame[0] == 10
      next_next_frame = frames[index + 2]
      bonus = 10 + next_next_frame[0]
    else
      bonus = next_frame.sum
    end
    point += 10 + bonus
  elsif frame.sum == 10
    next_frame = frames[index + 1]
    bonus = next_frame[0]
    point += 10 + bonus
  else
    point += frame.sum
  end
end

point += frames[9..].flatten.sum if frames[9..]

puts point
