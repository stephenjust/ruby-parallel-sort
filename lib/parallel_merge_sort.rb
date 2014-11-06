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

      #puts "attempting merge : [#{leftStart}, #{leftEnd}], [#{rightStart}, #{rightEnd}]"
      tempArr = merge(items, leftStart, leftEnd, rightStart, rightEnd, comparator)
      tempArr.each_with_index do |val, index|
        items[left + index] = val
      end
    end

    public
    def b_find_parition(target, arr, first = 0, last = arr.length - 1)
      #puts "b_search for #{target} : #{arr.slice(first, last - first + 1)}"
      idx = first
      while first <= last
        idx = (last - first) / 2 + first
        return idx if arr[idx] == target
        last = idx - 1 if arr[idx] > target
        first = idx + 1 if arr[idx] < target
      end
      return idx - 1 if target < arr[idx]
      return idx
    end
    
    public
    def merge(items, leftStart, leftEnd, rightStart, rightEnd, comparator)
      #puts "#{items}"
      #puts "merge : [#{leftStart}, #{leftEnd}], [#{rightStart}, #{rightEnd}] \t #{items.slice(leftStart, leftEnd - leftStart + 1)} : #{items.slice(rightStart, rightEnd - rightStart + 1)}"
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
          result.reverse! if result[0] > result[1]
        else
          result = [items[leftStart]]
        end
      else
        # left array is at least length 1
        median_left_idx = leftStart + (left_len - 1) / 2
        right_partition_idx = b_find_parition(items[median_left_idx], items, rightStart, rightEnd)
        #puts "bFind returned : #{right_partition_idx}"
        
        arrLeft = nil
        arrRight = []
        
        #t1 = Thread.new do || 
          if rightStart <= right_partition_idx
            arrLeft = merge(items, leftStart, median_left_idx, rightStart, right_partition_idx, comparator)
          else
            arrLeft = items.slice(leftStart, median_left_idx - leftStart + 1)
            #puts "slicing left : #{arrLeft}"
          end
        #end
        #t2 = Thread.new do ||
          if right_partition_idx + 1 <= rightEnd
            arrRight = merge(items, median_left_idx + 1, leftEnd, right_partition_idx + 1, rightEnd, comparator)
          else
            arrRight = items.slice(median_left_idx + 1, leftEnd - median_left_idx)
            #puts "slicing Right : #{arrRight}"
          end
        #end
        
        #t1.join
        #t2.join
        
        #puts "left : #{arrLeft}, right : #{arrRight}"
        #puts "merge : [#{leftStart}, #{leftEnd}], [#{rightStart}, #{rightEnd}] \t #{items.slice(leftStart, leftEnd - leftStart + 1)} : #{items.slice(rightStart, rightEnd - rightStart + 1)}"
        #now join the two and return
        arrRight.each do |val|
          arrLeft << val
        end
        
        result = arrLeft
        
        #puts "partioned at : #{median_left_idx} and #{right_partition_idx} \t #{items}"
      end
      
      #puts "merge result : #{result} over range : [#{leftStart}, #{leftEnd}], [#{rightStart}, #{rightEnd}]"
      post_merge(result, comparator)
      return result
    end
  end
end
