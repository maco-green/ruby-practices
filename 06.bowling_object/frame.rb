# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(marks)
    @shots = marks.map { |mark| Shot.new(mark) }
  end

  def strike?
    @shots[0].pins == 10
  end

  def spare?
    @shots.size == 2 && score == 10
  end

  def score
    @shots.map(&:pins).sum
  end

  def shot_size
    @shots.size
  end

  def first_pins
    @shots[0].pins
  end

  def second_pins
    @shots[1].pins
  end
end
