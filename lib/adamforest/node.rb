# frozen_string_literal: true

module Node
  include Helper

  def self.init_from_data(data, forest_helper: Helper, depth: 0, max_depth: Math.log(data.length, 2).ceil)
    return OutNode.new(data, depth) if data.nil? || data.length <= 1 || depth == max_depth

    split_point = forest_helper.forest_count_split_point(data)
    left_group, right_group = node_group_by(data, split_point, forest_helper: forest_helper)

    InNode.new(
      init_from_data(left_group, forest_helper: forest_helper, depth: depth + 1, max_depth: max_depth),
      init_from_data(right_group, forest_helper: forest_helper, depth: depth + 1, max_depth: max_depth),
      split_point,
    )
  end

  def self.node_group_by(data, split_point, forest_helper: Helper)
    data.group_by { |x| forest_helper.element_decision(x, split_point) }.values_at(true, false)
  end

  class OutNode
    def initialize(data, depth)
      @data = data
      @depth = depth
    end

    attr_reader :data, :depth

    def evaluate_depth(*)
      @depth
    end

    def to_j
      { data: @data, depth: @depth }
    end

    def to_a
      @data
    end
  end

  class InNode
    def initialize(left, right, split_point)
      @left = left
      @right = right
      @split_point = split_point
    end

    attr_reader :left, :right, :split_point

    def evaluate_depth(element, forest_helper: Helper)
      next_node = forest_helper.element_decision(element, @split_point) ? @left : @right
      next_node.evaluate_depth(element, forest_helper: forest_helper)
    end

    def to_j
      { "left": @left.to_j, "right": @right.to_j, "SP": @split_point.to_j }
    end

    def to_a
      [@left.to_a, @right.to_a]
    end
  end
end
