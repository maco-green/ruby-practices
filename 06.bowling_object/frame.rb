# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(marks)
    @shots = marks.map { |mark| Shot.new(mark) }
  end

  def strike?
    @shots[0].point == 10
  end

  def spare?
    @shots.size == 2 && score == 10
  end

  def score
    @shots.map(&:point).sum
  end

  def first_point
    @shots[0].point
  end

  def shot_size
    @shots.size
  end

  def first_two_points
    @shots[0].point + @shots[1].point
  end
end
