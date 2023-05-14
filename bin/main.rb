# frozen_string_literal: true

require "bundler/setup"
require "adamforest"

include AdamForest

puts "main"

s = Node.init_from_data([1000, 50, 3, 1], ForestHelperService)

p s.to_j
