# frozen_string_literal: true

require "bundler/setup"
require "adamforest"

include AdamForest

puts "main"

s = Node.init_from_data([[1,1],[2, 2],[3, 3], [7, 1000]], ForestHelperServiceDimensional)

p s.to_j


p Node.evaluate_node(s, {}, {})

p Forest.init_from_data([[1,1],[2, 2],[3, 3], [7, 1000]], 5, ForestHelperServiceDimensional)


#fs = ForestHelperServiceDimensional.forest_count_split_point([[2, 2], [3, 3], [7, 8]])
#p ForestHelperServiceDimensional.node_group_by([[2, 2], [3, 3], [7, 8]], fs)
