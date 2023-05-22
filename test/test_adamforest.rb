# frozen_string_literal: true

require "test_helper"
require "adamforest/services/helper_mock"
require "adamforest/services/helper"

class Float
  def to_h
    self
  end
end

class TestAdamforest < Minitest::Test
  include AdamForest

  def test_that_it_has_a_version_number
    refute_nil ::Adamforest::VERSION
  end

  def test_node_created
    node = InNode.new(nil, nil, 3)
    assert_nil node.left
    assert_nil node.right
    assert_equal node.split_point, 3
  end

  def test_init_from_data
    helper_mock = Class.new do
      def self.forest_count_split_point(data)
        (data.min + data.max) / 2.0
      end

      def self.element_decision(element, split_point)
        element < split_point
      end
    end

    node = Node.init_from_data([1, 2, 3], forest_helper: helper_mock)
    assert_equal node.to_a, [[1], [[2], [3]]]
    # assert_equal node.splitPoint, 3
  end

  def test_dimensional_group_by
    split_d = SplitPointD.new(7, 1)
    res = Node.node_group_by([[2, 2], [3, 3], [7, 8]], split_d.split_point, forest_helper: HelperMock)
    assert_equal res[1], [[7, 8]]
  end

  def test_forest_creation
    forest = Forest.new([[2, 2], [3, 3], [7, 8]], trees_count: 3, forest_helper: HelperMock)
    assert_equal forest.trees.count, 3
  end

  def test_evaluate_depth
    s = Node.init_from_data([[1, 1], [2, 2], [3, 3], [7, 1000]], forest_helper: HelperMock, max_depth: 3)
    assert_equal 3, s.evaluate_depth([2, 2], forest_helper: HelperMock)
    assert_equal 1, s.evaluate_depth([4, 8], forest_helper: HelperMock)
    assert_equal 2, s.evaluate_depth([1.5, 8], forest_helper: HelperMock)
  end

  def test_evaluate_forest
    forest = Forest.new([[1, 1], [2, 2], [3, 3], [7, 1000]], trees_count: 3, forest_helper: HelperMock, max_depth: 3)
    assert_equal [3, 3, 3], forest.evaluate_forest([2, 2])
  end

  def test_path_length_c
    res4 = Helper.evaluate_path_length_c(4)
    assert_operator 2, :<, res4

    res7 = Helper.evaluate_path_length_c(7)
    assert_operator 3, :<, res7

    res0 = Helper.evaluate_path_length_c(0)
    assert_equal res0, 0

    res2 = Helper.evaluate_path_length_c(2)
    assert_equal res2, 1

    res1 = Helper.evaluate_path_length_c(1)
    assert_equal res1, 0
  end

  def test_helper_mock_ahoj
    res = HelperMock.evaluate_path_length_c(5)
    assert_equal res, 0
  end
end
