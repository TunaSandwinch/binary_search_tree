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
    next_node = current_node.value >= value ? current_node.left_child : current_node.right_child
    return nil if next_node.nil?
    return del_node(current_node) if value == root.value
    return del_node(next_node, current_node) if next_node.value == value

    delete(value, next_node)
  end

  def level_order # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    result = []
    known_nodes = [root]
    until known_nodes.empty?
      result << if block_given?
                  yield(known_nodes[0].value)
                else
                  known_nodes[0].value
                end
      known_nodes << known_nodes[0].left_child unless known_nodes[0].left_child.nil?
      known_nodes << known_nodes[0].right_child unless known_nodes[0].right_child.nil?
      known_nodes.shift
    end
    result
  end

  def rec_level_order(known_nodes = [root], accumulator = []) # rubocop:disable Metrics/AbcSize
    return if known_nodes.empty?

    known_nodes << known_nodes[0].left_child unless known_nodes[0].left_child.nil?
    known_nodes << known_nodes[0].right_child unless known_nodes[0].right_child.nil?
    accumulator << (block_given? ? yield(known_nodes[0].value) : known_nodes[0].value)
    known_nodes.shift
    rec_level_order(known_nodes, accumulator)
    accumulator
  end

  def in_order
    result = []

    helper = lambda do |current_node|
      return if current_node.nil?

      helper.call(current_node.left_child)
      result << (block_given? ? yield(current_node.value) : current_node.value)
      helper.call(current_node.right_child)
    end

    helper.call(root)
    result
  end

  def pre_order
    result = []

    traverse = lambda do |current_node|
      return if current_node.nil?

      result << (block_given? ? yield(current_node.value) : current_node.value)
      traverse.call(current_node.left_child)
      traverse.call(current_node.right_child)
    end

    traverse.call(root)
    result
  end

  def post_order
    result = []

    traverse = lambda do |current_node|
      return if current_node.nil?

      traverse.call(current_node.left_child)
      traverse.call(current_node.right_child)
      result << (block_given? ? yield(current_node.value) : current_node.value)
    end

    traverse.call(root)
    result
  end

  private

  def del_node(address, prev_node = nil) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    if address.left_child.nil? && address.right_child.nil?
      prev_node.value > address.value ? prev_node.left_child = nil : prev_node.right_child = nil
    elsif address.left_child.nil?
      address.value = address.right_child.value
      address.right_child = address.right_child.right_child
      address.left_child = address.right_child.left_child
    else
      successor = lowest_node(address.right_child)
      delete(successor.value)
      address.value = successor.value
    end
  end

  def lowest_node(address)
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

array = [1, 2, 3, 4, 5, 6, 7]
test = Tree.new(array)
test.print_bst

what = test.post_order do |item|
  "now at: #{item}"
end
p what
