# frozen_string_literal: true

require_relative 'lib/tree'

tree = Tree.new(Array.new(15) { rand(1..100) })
p tree.balance?
puts 'inorder'
tree.in_order do |item|
  print " #{item}"
end
puts ''
puts 'preorder'
tree.pre_order do |item|
  print " #{item}"
end
puts ''
puts 'postorder'
tree.post_order do |item|
  print " #{item}"
end
puts ''
tree.insert(102)
tree.insert(105)
tree.insert(107)
tree.insert(111)
tree.insert(145)
p tree.balance?
tree.rebalance
p tree.balance?
puts 'inorder'
tree.in_order do |item|
  print " #{item}"
end
puts ''
puts 'preorder'
tree.pre_order do |item|
  print " #{item}"
end
puts ''
puts 'postorder'
tree.post_order do |item|
  print " #{item}"
end
puts ''
