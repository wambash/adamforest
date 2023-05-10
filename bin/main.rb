require "bundler/setup"
require "adamforest"

include AdamForest

puts "main"


helperMock = Class.new do
  def self.forestCountSplitPoint(data)
    (data[0] + data[1]) / 2.0
  end
end

s = Node.initFromData([1000, 50, 3, 1], ForestHelperService)

p s.to_j