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
  def self.sortItems(items, comparator)
    return items if items.length == 1

    left = sortItems(items.slice(0, items.length / 2), comparator).reverse
    right = sortItems(items.slice(left.length, items.length), comparator).reverse

    items.map! do ||
      a = left.last
      b = right.last
      result = nil
      result = a if b == nil
      result = b if a == nil
      result = a if result == nil and (comparator.call(b, a) > 0)
      result ||= b
      if result == a
        left.pop
      else
        right.pop
      end
      result
    end

    return items
  end

end

arr = [5, 3, 1, 5, 6, 0, 1, 9, 1]
ParallelMergeSort.pSort(arr, 1000)
puts "#{arr}"