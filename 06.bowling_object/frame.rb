# frozen_string_literal: true

require_relative 'shot'

class Frame
  PINS_PER_FRAME = 10
  SHOTS_PER_FRAME = 2

  def initialize(marks)
    @shots = marks.map { |mark| Shot.new(mark) }
  end

  def strike?
    @shots[0].pins == PINS_PER_FRAME
  end

  def spare?
    @shots.size == SHOTS_PER_FRAME && score == PINS_PER_FRAME
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
    @shots[1]&.pins
  end
end
