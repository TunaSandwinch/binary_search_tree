# frozen_string_literal: true

require_relative 'node'
require_relative 'sort'
# tree class
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(sort(array.uniq))
  end

  def print_bst(node = root, prefix = '', is_left = true)
    return if node.nil?

    print_bst(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false)
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    print_bst(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true)
  end

  def insert(value, current_node = root)
    path = current_node.value > value ? current_node.left_child : current_node.right_child
    if path.nil?
      return current_node.value >= value ? current_node.left_child = Node.new(value, nil,
                                                                              nil) : current_node.right_child = Node.new(
                                                                                value, nil, nil
                                                                              )
    end
    return if current_node.value == value

    insert(value, path)
  end

  def delete(value, current_node = root)
    path = current_node.value > value ? current_node.left_child : current_node.right_child
    return nil if path.nil?
    return del_root if root.value == value

    return del_node(path, current_node) if path.value == value

    # play around path
    # del node goes on infinite loop
    delete(value, path)
  end

  private

  def build_tree(array) # rubocop:disable Metrics/AbcSize
    mid = array.length / 2
    left = array[0..mid - 1]
    right = array[(mid + 1)..array.length]
    return Node.new(array[mid], nil, nil) if array.length == 1

    return Node.new(array[mid], build_tree(left), nil) if array.length == 2

    Node.new(array[mid], build_tree(left), build_tree(right))
  end
end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

test = Tree.new(array)
test.insert(24)
test.delete(67)
test.print_bst
