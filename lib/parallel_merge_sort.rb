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

    public
    def b_find_parition(target, arr, first = 0, last = arr.length - 1, comparator)
      idx = first
      while first <= last
        idx = (last - first) / 2 + first
        return idx if comparator.call(arr[idx], target) == 0
        last = idx - 1 if comparator.call(arr[idx], target) > 0
        first = idx + 1 if comparator.call(arr[idx], target) < 0
      end
      return idx - 1 if comparator.call(target, arr[idx]) < 0
      return idx
    end
    
    public
    def merge(items, leftStart, leftEnd, rightStart, rightEnd, comparator)
      pre_merge(items, leftStart, leftEnd, rightStart, rightEnd)

      result = nil
      left_len = leftEnd - leftStart + 1
      right_len = rightEnd - rightStart + 1
      
      # ensure first array is always greater than second array
      if right_len > left_len
        result = merge(items, rightStart, rightEnd, leftStart, leftEnd, comparator)
      elsif left_len == 1
        if right_len == 1
          result = [items[leftStart], items[rightStart]] 
          result.reverse! if comparator.call(result[0], result[1]) > 0
        else
          result = [items[leftStart]]
        end
      else
        # left array is at least length 1
        median_left_idx = leftStart + (left_len - 1) / 2
        right_partition_idx = b_find_parition(items[median_left_idx], items, rightStart, rightEnd, comparator)
        
        arrLeft = nil
        arrRight = []
        
        t1 = Thread.new do || 
          if rightStart <= right_partition_idx
            arrLeft = merge(items, leftStart, median_left_idx, rightStart, right_partition_idx, comparator)
          else
            arrLeft = items.slice(leftStart, median_left_idx - leftStart + 1)
          end
        end
        t2 = Thread.new do ||
          if right_partition_idx + 1 <= rightEnd
            arrRight = merge(items, median_left_idx + 1, leftEnd, right_partition_idx + 1, rightEnd, comparator)
          else
            arrRight = items.slice(median_left_idx + 1, leftEnd - median_left_idx)
          end
        end
        
        t1.join
        t2.join
        
        #now join the two and return
        arrRight.each do |val|
          arrLeft << val
        end
        
        result = arrLeft
      end
      
      post_merge(result, comparator)
      return result
    end
  end
end
