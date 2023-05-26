# frozen_string_literal: true

require "test_helper"
require "adamforest/services/isolation"

class TestServiceIsolation < Minitest::Test
  include AdamForest

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
