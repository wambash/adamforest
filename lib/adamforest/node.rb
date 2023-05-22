# frozen_string_literal: true

module Node
  include Helper

  def self.init_from_data(data, forest_helper: Helper, depth: 0, max_depth: Math.log(data.length, 2).ceil)
    return OutNode.new(data, depth) if forest_helper.end_condition(data, depth, max_depth)

    node_groups = forest_helper.get_node_groups(data)

    InNode.new(
      node_groups.transform_values { |group|
        init_from_data(group, forest_helper: forest_helper, depth: forest_helper.depth_transform(group, depth), max_depth: max_depth)
      },
      forest_helper.get_decision(data)
    )
  end

  OutNode = Data.define(:data, :depth) do
    def to_a
      data
    end
  end

  InNode = Data.define(:branches, :decision) do
    def to_a
      branches.values.map(&:to_a)
    end
  end
end
