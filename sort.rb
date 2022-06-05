# Implements a merge sort algorithm
module Sort
  def merge(left, right)
    merged = []
    until left.length.zero? && right.length.zero?
      return merged.push(left).flatten if right[0].nil?
      return merged.push(right).flatten if left[0].nil?

      left[0] <= right[0] ? merged.push(left.shift) : merged.push(right.shift)
    end
    merged
  end

  def merge_sort(array)
    return array if array.length == 1

    size = array.length / 2 - 1
    sorted_left = merge_sort(array[0..size])
    sorted_right = merge_sort(array[size + 1..])

    merge(sorted_left, sorted_right)
  end
end