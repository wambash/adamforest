# frozen_string_literal: true

require_relative "adamforest/version"
require_relative "adamforest/services/isolation"
require_relative "adamforest/services/helper_mock"
require_relative "adamforest/node"

module AdamForest
  include Node
  include Isolation

  class Forest
    attr_reader :trees, :forest_helper, :batch_size

    def initialize(
      data,
      trees_count: 100,
      forest_helper: Isolation,
      batch_size: 128,
      max_depth: Math.log(batch_size, 2).ceil,
      random: Random
    )
      @forest_helper = forest_helper
      @trees = trees_count.times.map { |_| Node.init_from_data(forest_helper.get_sample(data, batch_size, random: random), forest_helper: @forest_helper, max_depth: max_depth) }
      @batch_size = batch_size
    end

    def evaluate_forest(element)
      trees.map { |tree| Node.walk_nodes(tree, element, forest_helper: @forest_helper) }
    end
  end
end
