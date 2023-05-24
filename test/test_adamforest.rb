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

  def test_init_from_data
    node = Node.init_from_data([1, 2, 3], forest_helper: HelperMock)
    assert_equal node.to_a, [[[1, 3]], [2]]
    # assert_equal node.splitPoint, 3
  end

  def test_dimensional_group_by
    res = HelperMock.get_node_groups([[2, 2], [3, 3], [7, 8]])
    assert_equal res[false], [[7, 8]]
  end

  def test_forest_creation
    forest = Forest.new([[2, 2], [3, 3], [7, 8]], trees_count: 3, forest_helper: HelperMock)
    assert_equal forest.trees.count, 3
  end

  def test_evaluate_depth
    s = Node.init_from_data([[1, 1], [2, 2], [3, 3], [7, 1000]], forest_helper: HelperMock, max_depth: 3)
    assert_equal 3, Node.evaluate_path_length(s, [2, 2], forest_helper: HelperMock).depth
    assert_equal 1, Node.evaluate_path_length(s, [4, 8], forest_helper: HelperMock).depth
    assert_equal 2, Node.evaluate_path_length(s, [1.5, 8], forest_helper: HelperMock).depth
  end

  def test_evaluate_forest
    forest = Forest.new([[1, 1], [2, 2], [3, 3], [7, 1000]], trees_count: 3, forest_helper: HelperMock, max_depth: 3)
    assert_equal([3, 3, 3], forest.evaluate_forest([2, 2]).flat_map(&:depth))
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

  def test_helper_evaluate_anomaly_score_s
    # if sample size -1 == average, then 0
    # [1,2,3] are depths of 3 trees
    res0 = Helper.evaluate_anomaly_score_s([9999], 10000)
    assert_in_delta res0, 0

    res1 = Helper.evaluate_anomaly_score_s([-1, 0, 1], 3)
    assert_equal res1, 1

    res05 = Helper.evaluate_anomaly_score_s([Helper.evaluate_path_length_c(100)], 100)
    assert_equal res05, 0.5
  end
end
