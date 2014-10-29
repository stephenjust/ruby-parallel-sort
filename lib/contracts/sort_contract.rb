require 'test/unit/assertions'

module Contracts
  module Sort

    def pre_sort(items)
      assert items.respond_to?(:length), "Items must have a length."
      assert items.respond_to?(:[]), "Items must be indexable."
      items.each do |i|
        assert_not_nil i, "Items cannot contain a nil value."
      end
    end

    def post_sort(items, ret)
      assert_equal items.length, ret.length, "Sorted list must be the same length as the original."
      (items.length-1).times do |i|
        assert ret[i] <= ret[i+1], "Items must be sorted. Got #{ret[i]} and #{ret[i+1]}."
      end
    end

    def pre_merge(a, b)
      assert a.length > 0, "List A may not be empty."
      assert b.length > 0, "List B may not be empty."
      (a.length-1).times do |i|
        assert a[i] <= a[i+1], "Items must be sorted. Got #{a[i]} and #{a[i+1]}."
      end
      (b.length-1).times do |i|
        assert b[i] <= b[i+1], "Items must be sorted. Got #{b[i]} and #{b[i+1]}."
      end      
    end

    def post_merge(a, b, ret)
      assert_equal a.length+b.length, ret.length, "Length of merged lists must be sum of list lengths."
      (ret.length-1).times do |i|
        assert ret[i] <= ret[i+1], "Items must be sorted. Got #{ret[i]} and #{ret[i+1]}."
      end
    end
    
  end
end
