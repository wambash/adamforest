# frozen_string_literal: true

require "test_helper"
require "adamforest/services/quicksort"


class TestServiceQuicksort < Minitest::Test
  include AdamForest
  include QuickSort

  def test_quick_sort_neighbours
    input = [5, 8, 3, 4, 2, 7]
    forest = Forest.new(input, trees_count: 1, forest_helper: QuickSort.new)
    res = forest.evaluate_forest(6).first
    assert_equal res, [7]
  end

  def test_quick_sort_sorting
    input = [5, 8, 3, 4, 2, 7]
    forest = Forest.new(input, trees_count: 1, forest_helper: QuickSort.new)
    res = forest.trees.first.to_a.flatten
    assert_equal res, [2,3,4,5,7,8]
  end
end
