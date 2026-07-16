#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    @marks = marks.split(',')
  end

  def frames
    @frames ||= begin
      result = []
      until result.size == 9
        if @marks[0] == "X"
          result << @marks.shift(1)
        else
          result << @marks.shift(2)
        end
      end
      result << @marks
      result.map { |marks| Frame.new(marks) }
    end
  end

  def total_score
    total = 0
    frames.first(9).each_with_index do |frame, index|
      if frame.strike?
        if frames[ index + 1 ].shot_size == 1
          total += frame.score + frames[ index + 1 ].score + frames[ index + 2 ].first_point
        else
          total += frame.score + frames[ index + 1 ].first_two_points
        end
      elsif frame.spare?
        total += frame.score + frames[ index + 1 ].first_point
      else
        total += frame.score
      end
    end
    total += frames[9].score
    total
  end
end

game = Game.new(ARGV[0])
puts game.total_score
