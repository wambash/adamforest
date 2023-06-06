# frozen_string_literal: true

require "test_helper"
require "adamforest/services/isolation"

class TestServiceIsolation < Minitest::Test
  include AdamForest

  def test_anomaly_score
    input = [[1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [2, 2]]

    forest = Forest.new(input, trees_count: 4)

    anomaly = forest.evaluate_forest([2, 2])
    a_depths = anomaly.map(&:depth)

    regular = forest.evaluate_forest([1, 1])
    r_depths = regular.map(&:depth)

    assert_operator Isolation.evaluate_anomaly_score_s(a_depths, input.size), :>, 0.6
    assert_operator Isolation.evaluate_anomaly_score_s(r_depths, input.size), :<, 0.5
  end

  def test_isolation_anomaly_score_s
    # if sample size -1 == average, then 0
    # [1,2,3] are depths of 3 trees
    res0 = Isolation.evaluate_anomaly_score_s([9999], 10000)
    assert_in_delta res0, 0

    res1 = Isolation.evaluate_anomaly_score_s([-1, 0, 1], 3)
    assert_equal res1, 1

    res05 = Isolation.evaluate_anomaly_score_s([Isolation.evaluate_path_length_c(100)], 100)
    assert_equal res05, 0.5
  end

  def test_path_length_c
    res4 = Isolation.evaluate_path_length_c(4)
    assert_operator 2, :<, res4

    res7 = Isolation.evaluate_path_length_c(7)
    assert_operator 3, :<, res7

    res0 = Isolation.evaluate_path_length_c(0)
    assert_equal res0, 0

    res2 = Isolation.evaluate_path_length_c(2)
    assert_equal res2, 1

    res1 = Isolation.evaluate_path_length_c(1)
    assert_equal res1, 0
  end
end
