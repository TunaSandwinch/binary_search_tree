# frozen_string_literal: true

require_relative 'node'
require_relative 'sort'
# tree class
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(sort(array.uniq))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
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
    return del_root if current_node.value == value
    return 'left' if current_node.left_child.value == value
    return 'right' if current_node.right_child.value == value

    delete(value, path)
  end

  private

  def del_root # rubocop:disable Metrics/AbcSize
    if root.right_child.left_child.nil?
      successor = root.right_child
      @root = (successor.left_child = root.left_child)
    else
      successor = lowest_node(root.right_child)
      successor.left_child = root.left_child
      prev_node(successor).left_child = successor.right_child # current child of successor
      @root = successor.right_child = root.right_child # assign new child to the successor
      @root = successor
    end
  end

  def prev_node(address, current_node = root)
    path = current_node.value > address.value ? current_node.left_child : current_node.right_child
    return nil if address.value == root.value
    return current_node if path.value == address.value

    # stack level too deeep
    # find a way to play around path
    prev_node(address, path)
  end

  def lowest_node(address = root)
    return address if address.left_child.nil?

    lowest_node(address.left_child)
  end

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
test.insert(500)
test.pretty_print
test.delete(8)
puts ' '
test.pretty_print
