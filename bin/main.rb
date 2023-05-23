# frozen_string_literal: true

require "bundler/setup"
require "adamforest"

include AdamForest

puts "main"

forest = Forest.new([[1, 1], [2, 2], [3, 3], [7, 1000]], trees_count: 5)

evaluation = forest.evaluate_forest([2.5, 1.5])
p evaluation
