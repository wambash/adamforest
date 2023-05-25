# frozen_string_literal: true

module QuickSort
  def self.forest_count_split_point(data)
    data.first
  end

  def self.get_node_groups(data, decision_fun)
    { -1 => [], 0 => [], 1 => [] }.merge(data.group_by(&decision_fun))
  end

  def self.get_initial_decision(data)
    sp = forest_count_split_point(data)

    ->(x) { x <=> sp }
  end

  def self.out_node_depth_adjust(data, depth)
    depth
  end

  def self.depth_transform(group, depth)
    depth + 1
  end

  def self.end_condition(data, depth, max_depth)
    data.all? { |x| x == data.first }
  end
end