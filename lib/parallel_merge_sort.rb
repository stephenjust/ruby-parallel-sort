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
  def self.sortItems(items, comparator, left=0, right=items.length)
    return unless right > left
    
    mid = (left + right) / 2
    t1 = Thread.new do ||
      sortItems(items, comparator, left, mid)
    end
    t2 = Thread.new do ||
      sortItems(items, comparator, mid + 1, right)
    end
    
    t1.join
    t2.join
    
    leftStart = left
    leftEnd = mid
    rightStart = mid + 1
    rightEnd = right
    
    tempArr = (right - left).times do ||
      a = items[leftEnd] if leftEnd >= leftStart
      b = items[rightEnd] if rightEnd >= rightStart
      result = nil
      result = a if b == nil
      result = b if a == nil
      result = a if result == nil and (comparator.call(a, b) > 0)
      result ||= b
      if result == a
        leftStart -= 1
      else
        rightStart -= 1
      end
      result
    end
  end

end

size = 1000
arr = []
size.times do |i|
  arr << size - i
end
ParallelMergeSort.pSort(arr, 1000)
puts "#{arr}"