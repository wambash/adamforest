# frozen_string_literal: true

require "bundler/setup"
require "adamforest"

include AdamForest

puts "main"

batch_size = 128
forest = Forest.new([[1, 1], [2, 2], [3, 3],[1, 1], [2, 2], [3, 3],[1, 1], [2, 2], [3, 3],[1, 1], [2, 2], [3, 3], [10000, 1000]], trees_count: 4, batch_size: batch_size)

# evaluation = forest.evaluate_forest([2.5, 1.5])
# If instances return s very close to 1, then they are definitely anomalies,
depths = forest.evaluate_forest_return_depths([10000, 10000])
s = Helper.evaluate_anomaly_score_s(depths, batch_size)
p s
