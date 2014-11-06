require 'timeout'

require_relative './contracts/sort_contract'

module ParallelMergeSort
  class Sorter
    include Contracts::Sort
    def pSort(items, duration, comparator = nil)
      pre_sort(items)
      comparator ||= Proc.new do |a, b|
        a <=> b
      end

      original = items.clone

      Timeout::timeout(duration) do ||
        sortItems(items, comparator)
      end

      post_sort(original, items, comparator)
    end

    private
    def sortItems(items, comparator, left=0, right=items.length - 1)
      return unless right > left

      mid = (left + right) / 2
      leftStart = left
      leftEnd = mid
      rightStart = mid + 1
      rightEnd = right

      t1 = Thread.new do ||
        sortItems(items, comparator, leftStart, leftEnd)
      end
      t2 = Thread.new do ||
        sortItems(items, comparator, rightStart, rightEnd)
      end

      t1.join
      t2.join

      tempArr = merge(items, leftStart, leftEnd, rightStart, rightEnd, comparator)
      tempArr.each_with_index do |val, index|
        items[left + index] = val
      end
    end

    def merge(items, leftStart, leftEnd, rightStart, rightEnd, comparator)
      pre_merge(items, leftStart, leftEnd, rightStart, rightEnd)

      tempArr = []
      right = rightEnd
      left = leftStart

      (right - left + 1).times do ||
        a = items[leftStart] if leftEnd >= leftStart
        b = items[rightStart] if rightEnd >= rightStart
        result = nil
        result = a if b == nil
        result = b if a == nil
        result = a if result == nil and (comparator.call(b, a) > 0)
        result ||= b
        if result == a
          leftStart += 1
        else
          rightStart += 1
        end
        tempArr << result
      end

      post_merge(items, leftStart, leftEnd, rightStart, rightEnd, comparator)

      return tempArr
    end
  end
end
