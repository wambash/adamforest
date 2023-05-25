# frozen_string_literal: true

require "bundler/setup"
require "adamforest"
require "adamforest/services/quicksort"

include AdamForest

puts "main"

input = [[1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [2, 2]]
forest = Forest.new(input, trees_count: 4)
p forest.trees.map(&:to_h)
# If instances return s very close to 1, then they are definitely anomalies,
p forest.batch_size
depths = forest.evaluate_forest_return_depths([2, 2])
p depths
p Helper.evaluate_path_length_c(input.length)
p Helper.evaluate_average_e(depths)
s = Helper.evaluate_anomaly_score_s(depths, forest.batch_size)
p s

p "______"

depths = forest.evaluate_forest_return_depths([1, 1])
p depths
p Helper.evaluate_path_length_c(input.length)
p Helper.evaluate_average_e(depths)
s = Helper.evaluate_anomaly_score_s(depths, forest.batch_size)
p s

input = [5, 8, 3, 4, 2, 7]
forest = Forest.new(input, trees_count: 1, forest_helper: QuickSort)
p forest.trees.first.to_h
p forest.trees.first.to_a
p forest.evaluate_forest(6)

