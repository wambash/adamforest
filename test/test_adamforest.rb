# frozen_string_literal: true

require "test_helper"
require "adamforest/services/helper_mock"

class Float
  def to_h
    self
  end
end

class TestAdamforest < Minitest::Test
  include HelperMock
  include AdamForest

  def test_that_it_has_a_version_number
    refute_nil ::Adamforest::VERSION
  end

  def test_init_from_data
    node = Node.init_from_data([[1], [2], [3]], forest_helper: Mock.new)
    assert_equal node.to_a, [[[1]], [[[2]], [[3]]]]
    assert_equal node.split_point, (1 + 3) / 2.0
  end

  def test_forest_creation
    forest = Forest.new([[2, 2], [3, 3], [7, 8]], trees_count: 3, forest_helper: Mock.new)
    assert_equal forest.trees.count, 3
  end

  def test_walk_nodes
    hm = Mock.new(max_depth: 3)
    s = Node.init_from_data([[1, 1], [2, 2], [3, 3], [1000, 1000]], forest_helper: hm)
    assert_equal [[2, 2]], Node.walk_nodes(s, [2, 2], forest_helper: hm)
    assert_equal [[3, 3]], Node.walk_nodes(s, [4, 8], forest_helper: hm)
    assert_equal [[1000, 1000]], Node.walk_nodes(s, [600, 600], forest_helper: hm)
  end

  def test_evaluate_forest
    forest = Forest.new([[1, 1], [2, 2], [3, 3], [7, 1000]], trees_count: 3, forest_helper: Mock.new)
    assert_equal([[[2, 2]], [[2, 2]], [[2, 2]]], forest.evaluate_forest([2, 2]))
  end
end
