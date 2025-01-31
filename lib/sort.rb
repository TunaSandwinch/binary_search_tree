# frozen_string_literal: true

def sort(n) # rubocop:disable Naming/MethodParameterName,Metrics/AbcSize
  return n if n.length == 1
  return n[0] < n[1] ? n : [n[1], n[0]] if n.length == 2

  mid = n.length / 2
  left = n[0..(mid - 1)]
  right = n[mid..(n.length - 1)]
  merge(sort(left), sort(right))
end

def merge(left, right) # rubocop:disable Metrics/MethodLength
  result = []

  while !left.empty? || !right.empty?
    result << if left.empty?
                right.shift
              elsif right.empty?
                left.shift
              elsif left[0] < right[0] # rubocop:disable Lint/DuplicateBranch
                left.shift
              else # rubocop:disable Lint/DuplicateBranch
                right.shift
              end
  end
  result
end
