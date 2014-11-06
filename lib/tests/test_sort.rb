require 'test/unit'

require_relative '../parallel_merge_sort'

# Note: contracts will verify that code executes successfully!
class PromptTest < Test::Unit::TestCase

  def setup
    @sorter = ParallelMergeSort::Sorter.new
    @short_timeout = 0.01
    @long_timeout = 1000000
    @med_size = 300
    @large_size = 150
  end

  def test_emptyArray
    arr = []
    @sorter.pSort(arr, @long_timeout)
  end

  def test_smallArray
    arr = [9, 1, 4, 5, 23, 1, -6, 1, 2, 0]
    @sorter.pSort(arr, @long_timeout)
  end

  def test_largeArray
    arr = []
    @large_size.times do |i|
      arr << i + 1 if i % 2 == 0
      arr << @large_size - i if i % 2 == 1
    end
    @sorter.pSort(arr, @long_timeout)
  end

  def test_reverseArray
    arr = []
    @med_size.times do |i|
      arr << @med_size - i
    end
    @sorter.pSort(arr, @long_timeout)
  end

  def test_sortedArray
    arr = []
    @med_size.times do |i|
      arr << i
    end
    @sorter.pSort(arr, @long_timeout)
  end

  def test_timeout
    arr = []
    did_timeout = false
    @large_size.times do |i|
      arr << i
    end
    begin
      @sorter.pSort(arr, @short_timeout)
    rescue Timeout::Error => ex
      did_timeout = true
    end

    assert did_timeout, "failed to time-out in time-out test"
  end

end
