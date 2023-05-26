# frozen_string_literal: true

module Node
  include Isolation

  def self.init_from_data(data, forest_helper: Isolation, max_depth: Math.log(data.length, 2).ceil)
    return OutNode.new(data) if forest_helper.end_condition(data, max_depth)

    node_groups = forest_helper.get_node_groups(data)

    InNode.new(
      node_groups.transform_values do |group|
        init_from_data(group, forest_helper: forest_helper, max_depth: max_depth)
      end,
      data
    )
  end

  def self.walk_nodes(node, element, forest_helper: Isolation)
    return node if node.is_a?(OutNode)

    next_node_branch = forest_helper.get_data_decision(node.data).call(element)
    walk_nodes(node.branches[next_node_branch], element, forest_helper: forest_helper)
  end

  OutNode = Data.define(:data) do
    def to_a
      data
    end
  end

  InNode = Data.define(:branches, :data) do
    def to_a
      branches.values.map(&:to_a)
    end

    def to_h
      branches.values.map(&:to_h)
    end
  end
end
