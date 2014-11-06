gem 'test-unit'
require 'test/unit/assertions'

module Contracts
  module Sort
    include Test::Unit::Assertions

    def pre_sort(items)
      assert items.respond_to?(:length), "Items must have a length."
      assert items.respond_to?(:[]), "Items must be indexable."
      items.each do |i|
        assert_not_nil i, "Items cannot contain a nil value."
      end
    end

    def post_sort(items, ret, comparator)
      assert_equal items.length, ret.length, "Sorted list must be the same length as the original."
      (items.length-1).times do |i|
        assert comparator.call(ret[i], ret[i+1]) <= 0, "Items must be sorted. Got #{ret[i]} and #{ret[i+1]}."
      end
    end

    def pre_merge(items, leftStart, leftEnd, rightStart, rightEnd)
      assert items.length > rightEnd, "right edge goes off the end of the array"
      assert leftStart <= leftEnd, "the end cannot bypass the start"
      assert rightStart <= rightEnd, "the end cannot bypass the start"
      a_length = (leftEnd - leftStart) + 1
      b_length = (rightEnd - rightStart) + 1
      assert a_length >= 0, "List A may not be negative length. Got #{a_length}"
      assert b_length >= 0, "List B may not be negative length. Got #{b_length}"
      (a_length-1).times do |i|
        index = i + leftStart
        assert items[index] <= items[index + 1], "Items must be sorted. Got: #{items.slice(leftStart, rightEnd)}"
      end
      (b_length-1).times do |i|
        index = i + rightStart
        assert items[index] <= items[index + 1], "Items must be sorted. Got #{items[index]} and #{items[index + 1]}."
      end
    end

    def post_merge(items, comparator)
      (items.length-1).times do |index|
        assert comparator.call(items[index], items[index + 1]) <= 0, "Items must be sorted. Got: #{items}"
      end
    end
  end
end
