# frozen_string_literal: true

# node class
class Node
  attr_accessor :value, :left_child, :right_child

  def initialize(value, left_child, right_child)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end
end
