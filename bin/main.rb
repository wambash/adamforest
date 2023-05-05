require "bundler/setup"
require "adamforest"

include AdamForest


puts "main"

data = [1,2,3,4]
node = INode.initFromData(data)
res = data
    .lazy
    .nodeGroupBy(node.splitPoint)

puts res