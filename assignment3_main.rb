# ECE 421
# Assignment 3
#
# Jesse Tucker, Stephen Just

require_relative('./lib/parallel_merge_sort')

sorter = ParallelMergeSort::Sorter.new

# Sort some integers
arr = [5, 3, 1, 5, 2]
puts "before sort: #{arr}"
sorter.pSort(arr, 10)
puts "after sort: #{arr}"

# Sort some strings
arr = ["foo", "bar", "bat", "baz"]
puts "before sort: #{arr}"
sorter.pSort(arr, 10)
puts "after sort: #{arr}"

# Sort in reverse
rev_strsort = Proc.new { |a, b| b <=> a }
sorter.pSort(arr, 10, rev_strsort)
puts "after custom sort: #{arr}"

# Sort some large number of values
1000.times {|i| arr[i] = Random.rand}
start = Time.now
sorter.pSort(arr, 100)
puts "Sort of 1000 elements took #{Time.now - start} seconds"
