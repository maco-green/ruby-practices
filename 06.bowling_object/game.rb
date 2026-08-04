# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    marks = marks.split(',')
    result = []
    until result.size == 9
      result << if marks[0] == 'X'
                  marks.shift(1)
                else
                  marks.shift(2)
                end
    end
    result << marks
    @frames = result.map { |marks| Frame.new(marks) }
  end

  def total_score
    total = 0
    @frames.first(9).each_with_index do |frame, index|
      total += frame.score
      next if !frame.strike? && !frame.spare?

      total += @frames[index + 1].first_pins
      next unless frame.strike?

      total += @frames[index + 1].second_pins || @frames[index + 2].first_pins
    end
    total += @frames[9].score
    total
  end
end
