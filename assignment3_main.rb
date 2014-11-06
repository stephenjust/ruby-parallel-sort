# ECE 421
# Assignment 3
#
# Jesse Tucker, Stephen Just

require_relative('./lib/parallel_merge_sort')

sorter = ParallelMergeSort::Sorter.new

# Sort some integers
arr = [5, 3, 1, 5, 2]
puts "before sort: #{arr}"
sorter.pSort(arr, 1000)
puts "after sort: #{arr}"

# Sort some strings
arr = ["foo", "bar", "bat", "baz"]
puts "before sort: #{arr}"
sorter.pSort(arr, 1000)
puts "after sort: #{arr}"

# Sort in reverse
rev_strsort = Proc.new { |a, b| b <=> a }
sorter.pSort(arr, 1000, rev_strsort)
puts "after custom sort: #{arr}"
