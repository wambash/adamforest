# frozen_string_literal: true

require "test_helper"
require "adamforest/services/quicksort"


class TestServiceQuicksort < Minitest::Test
  include AdamForest

  def test_quick_sort
    input = [5, 8, 3, 4, 2, 7]
    forest = Forest.new(input, trees_count: 1, forest_helper: QuickSort, random: Random.new(3))
    p forest.trees.first.to_h
    p forest.trees.first.to_a
    p res = forest.evaluate_forest(6).first
    assert_equal res, [7]
  end
end
