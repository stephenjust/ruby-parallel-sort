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

      #Timeout::timeout(duration) do ||
        sortItems(items, comparator)
      #end

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

      #t1 = Thread.new do ||
        sortItems(items, comparator, leftStart, leftEnd)
      #end
      #t2 = Thread.new do ||
        sortItems(items, comparator, rightStart, rightEnd)
      #end

      #t1.join
      #t2.join

      puts "attempting merge : [#{leftStart}, #{leftEnd}], [#{rightStart}, #{rightEnd}]"
      tempArr = merge(items, leftStart, leftEnd, rightStart, rightEnd, comparator)
      tempArr.each_with_index do |val, index|
        items[left + index] = val
      end
    end

    public
    def b_find_parition(target, arr, first = 0, last = arr.length - 1)
      idx = first
      while first <= last
        idx = (last - first) / 2 + first
        return idx if arr[idx] == target
        last = idx - 1 if arr[idx] > target
        first = idx + 1 if arr[idx] < target
      end
      return idx
    end
    
    private
    def merge(items, leftStart, leftEnd, rightStart, rightEnd, comparator)
      puts "#{items}"
      puts "merge : [#{leftStart}, #{leftEnd}], [#{rightStart}, #{rightEnd}] \t #{items.slice(leftStart, leftEnd - leftStart)} : #{items.slice(rightStart, rightEnd - rightStart)}"
      pre_merge(items, leftStart, leftEnd, rightStart, rightEnd)

      result = nil
      left_len = leftEnd - leftStart + 1
      right_len = rightEnd - rightStart + 1
      
      # ensure first array is always greater than second array
      if right_len > left_len
        merge(items, rightStart, rightEnd, leftStart, leftEnd, comparator)
      elsif left_len == 1
        if right_len == 1
          result = [items[leftStart], items[rightStart]] 
          result.reverse! if result[0] > result[1]
        else
          result = [items[leftStart]]
        end
      else
        # left array is at least length 1
        median_left_idx = leftStart + (left_len - 1) / 2
        right_partition_idx = [b_find_parition(items[median_left_idx], items, leftStart, rightEnd), rightStart].max
        
        arrLeft = nil
        arrRight = nil
        
        #t1 = Thread.new do || 
          arrLeft = merge(items, leftStart, median_left_idx, rightStart, right_partition_idx, comparator) 
        #end
        #t2 = Thread.new do || 
          arrRight = merge(items, median_left_idx + 1, leftEnd, [right_partition_idx + 1, rightEnd].min, rightEnd, comparator)
        #end
        
        #t1.join
        #t2.join
        
        #now join the two and return
        arrRight.each do |val|
          arrLeft << val
        end
        
        result = arrLeft
      end
      
      puts "merge result : #{result}"
      post_merge(result, comparator)
      return result
    end
  end
end
