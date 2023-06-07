# frozen_string_literal: true

require "bundler/setup"
require "adamforest"
require "adamforest/services/quicksort"
require "adamforest/services/novelty"
require "adamforest/services/isolation"

include AdamForest
include Isolation
include Isolation::Numeric
include Service

puts "main"

input = [[1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [2, 2]]
forest = Forest.new(input, trees_count: 4, forest_helper: Isolation::Isolation.new)
# p forest.trees.map(&:to_h)
# If instances return s very close to 1, then they are definitely anomalies,
evaluation = forest.evaluate_forest([2, 2])
p evaluation

depths = evaluation.map(&:depth)
p depths
s = IsolationNumeric.evaluate_anomaly_score_s(depths, input.size)
p s

p "______"
evaluation = forest.evaluate_forest([1, 1])
depths = evaluation.map(&:depth)
p depths
s = IsolationNumeric.evaluate_anomaly_score_s(depths, input.size)
p s

input = [5, 8, 3, 4, 2, 7]
forest = Forest.new(input, trees_count: 1, forest_helper: QuickSort.new)
p forest.trees.first.to_h
p forest.trees.first.to_a
p forest.evaluate_forest(6)


input = [[1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [1, 1], [2, 2]]
forest = Forest.new(input, trees_count: 4, forest_helper: Novelty::Novelty.new)
forest.evaluate_forest([1, 1])
