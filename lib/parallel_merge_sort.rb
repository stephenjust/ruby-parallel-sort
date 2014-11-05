require 'timeout'

module ParallelMergeSort

  def self.pSort(items, duration, comparator = nil)
    comparator ||= Proc.new do |a, b|
      a <=> b
    end

    endTime = Time.now + duration
    sortItems(items, comparator)
  end

  private
  def self.sortItems(items, comparator, left=0, right=items.length - 1)
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
    
    tempArr = []
    
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
    
    tempArr.each_with_index do |val, index|
      items[left + index] = val
    end    
  end
end

size = 405
arr = []
size.times do |i|
  arr << size - i if i % 2 == 0
  arr << size + i if i % 2 == 1
end
init = arr.clone
ParallelMergeSort.pSort(arr, 1000)

puts "end : #{arr}"

init.sort!
init.each_with_index do |val, index|
  puts "not sorted...." if val != arr[index]
end