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
      a_length = (leftEnd - leftStart)
      b_length = (rightEnd - rightStart)
      assert a_length >= 0, "List A may not be negative length."
      assert b_length >= 0, "List B may not be negative length."
      (a_length-1).times do |i|
        index = i + leftStart
        assert items[index] <= items[index + 1], "Items must be sorted. Got #{items[index]} and #{items[index + 1]}."
      end
      (b_length-1).times do |i|
        index = i + rightStart
        assert items[index] <= items[index + 1], "Items must be sorted. Got #{items[index]} and #{items[index + 1]}."
      end
    end

    def post_merge(items, leftStart, leftEnd, rightStart, rightEnd, comparator)
      len = rightEnd - leftStart
      (len-1).times do |i|
        index = leftStart + i
        assert comparator.call(items[index], items[index + 1]) <= 0, "Items must be sorted. Got #{items[index]} and #{items[index + 1]}."
      end
    end
  end
end
