# frozen_string_literal: true

require "test_helper"
require "adamforest/services/novelty"

class TestServiceNovelty < Minitest::Test
  include AdamForest
  include Novelty

  def test_split_point_ranges
    datapoint = Novelty.new(batch_size: 128,random: Random.new(2)).get_sample([[1,1], [1,1]])
    assert_equal datapoint.ranges, [ 0..3000, 0..3000 ]
  end

  def test_group
    ns = Novelty.new(batch_size: 128,random: Random.new(2))
    datapoint =  ns.get_sample([[1,1], [1,1]])
    split_point = SplitPointD.new(100, 1)
    groups = ns.group(datapoint, split_point)
    
    assert_equal groups[true].ranges, [0..3000, 0...100]
    assert_equal groups[false].ranges, [0..3000, 100..3000]

    split_point2 = SplitPointD.new(200, 0)
    groups2 = ns.group(groups[true], split_point2)
    assert_equal groups2[true].ranges, [0...200, 0...100]
    assert_equal groups2[false].ranges, [200..3000, 0...100]
  end

  def test_novelty_run
    input = [[1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [2, 2]]

    forest = Forest.new(input, trees_count: 4, forest_helper: Novelty.new)

    anomaly = forest.evaluate_forest([2, 2])
    a_depths = anomaly.map(&:depth)

    regular = forest.evaluate_forest([1, 1])
    r_depths = regular.map(&:depth)

    novelty = forest.evaluate_forest([2999, 2999])
    n_depths = novelty.map(&:depth)

    assert_operator IsolationNumeric.evaluate_anomaly_score_s(r_depths, input.size), :<, 0.5
    assert_operator IsolationNumeric.evaluate_anomaly_score_s(a_depths, input.size), :<, 0.5
    assert_operator IsolationNumeric.evaluate_anomaly_score_s(n_depths, input.size), :>, 0.6
  end

end
