# frozen_string_literal: true

require "test_helper"
include AdamForest 

class TestAdamforest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Adamforest::VERSION
  end

  def test_add
    assert add(5,5) == 10
  end

  def test_node_created
    node = INode.new(nil, nil, 3)

    assert node.left == nil
    assert node.right == nil
    assert node.splitPoint == 3
  end

  def test_min_max
    min,max = INode.getMinMax([1,7,2,3])
    assert min == 1
    assert max == 7
  end

  def test_initFromData
    node = INode.initFromData([1,2,3,4])
    assert node.splitPoint.is_a?(Integer) == true
  end

  def test_node_groupBy
    grouped = [1,2,3,4].nodeGroupBy(3)
    assert grouped[true] == [1,2]
  end
end
