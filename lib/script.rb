load 'sort.rb'

class Node
  attr_accessor :value, :left, :right
  
  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end
end

class BinarySearchTree
  include Sort
  attr_accessor :root

  def initialize(array)
    @root = create_tree(merge_sort(array).uniq)

  end

  def create_tree(array)
    p array
    return nil if array == []
    return Node.new(array[0]) if array.length == 1

    mid = array.length / 2
    @root = Node.new(array[mid], create_tree(array[0..mid - 1]), create_tree(array[mid + 1..]))
  end

  def insert(value, node = @root)
    return nil if value == node.value

    if value < node.value && !node.left.nil?
      insert(value, node.left)
    elsif value > node.value && !node.right.nil? 
      insert(value, node.right)
    elsif value < node.value
      node.left = Node.new(value)
    else
      node.right = Node.new(value)
    end
  end

  def delete(value, node = @root)
    return nil if node.value.nil?

    if value < node.value
      node.left = delete(value, node.left)
    elsif value > node.value
      node.right = delete(value, node.right)
    elsif value == node.value && node.left.nil?
      node = node.right
    else
      node = node.left
    end
  end

  def level_order(queue = [@root], sorted_array = [])
    return nil if root.nil?
    return sorted_array if queue.empty? && !block_given?

    node = queue.shift
    queue.push(node.left) unless node.left.nil?
    queue.push(node.right) unless node.right.nil?
    sorted_array.push(node.value)
    level_order(queue, sorted_array)
  end

  def preorder(node = @root, sorted_array = [])
    return sorted_array if node.nil? && !block_given?

    sorted_array.push(node.value)
    preorder(node.left, sorted_array)
    preorder(node.right, sorted_array)
  end

  def inorder(node = @root, sorted_array = [])
    return sorted_array if node.nil? && !block_given?

    inorder(node.left, sorted_array)
    sorted_array.push(node.value)
    inorder(node.right, sorted_array)
  end

  def postorder(node = @root, sorted_array = [])
    return sorted_array if node.nil? && !block_given?

    postorder(node.left, sorted_array)
    postorder(node.right, sorted_array)
    sorted_array.push(node.value)
  end

  def height(node, count = 0)
    return count if node.left.nil? && node.right.nil?

    left_height = node.left.nil? ? 0 : height(node.left, count + 1)
    right_height = node.right.nil? ? 0 : height(node.right, count + 1)
    left_height >= right_height ? left_height : right_height
  end

  def depth(input, node = @root, count = 0)
    return count if input == node
    return nil if node.left.nil? && node.right.nil?
    return nil if input.nil?

    if node.left.nil?
      depth(input, node.right, count + 1)
    elsif node.right.nil?
      depth(input, node.left, count + 1)
    else
      input.value < node.value ? depth(input, node.left, count + 1) : depth(input, node.right, count + 1)
    end
  end

  def clean_nil(input)
    return 0 if input.nil?

    input
  end

  def balanced?(node = @root)
    return nil if @root.nil?

    if node.left.nil? && node.right.nil?
      true
    elsif node.left.nil?
      height(node.right, 1).between?(-1, 1)
    elsif node.right.nil?
      puts height(node.left, 1)
      height(node.left, 1).between?(-1, 1)
    else
      difference = height(node.left) - height(node.right)
      balanced?(node.left) && balanced?(node.right) && difference.between?(-1, 1)
    end
  end

  def rebalance
    return nil if self.balanced?

    array = self.inorder
    mid = array.length / 2
    @root = Node.new(array[mid], create_tree(array[0..mid - 1]), create_tree(array[mid + 1..]))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = BinarySearchTree.new([2, 6, 645, 7, 44, 3, 3, 6, 7])
tree.pretty_print
p tree.balanced?
tree.insert(88)
p tree.pretty_print
p tree.balanced?

p tree.rebalance
p tree.pretty_print

