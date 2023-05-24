# frozen_string_literal: true

module HelperMock
  def self.forest_count_split_point(data)
    min, max = data.flat_map { |x| x[0] }.minmax
    (min + max) / 2.0
  end

  def self.get_node_groups(data, decision_fun)
    { true => [], false => [] }.merge(data.group_by(&decision_fun))
  end

  def self.get_initial_decision(data)
    sp = forest_count_split_point(data)

    ->(x) { x[0] < sp }
  end

  def self.evaluate_path_length_c(_)
    0
  end

  def self.out_node_depth_adjust(data, depth)
    # when the traversal reaches a predefined height limit hlim, the return value is e plus an adjustment c(Size)
    depth + evaluate_path_length_c(data.length)
  end

  def self.depth_transform(group, depth)
    depth + 1
  end

  def self.end_condition(data, depth, max_depth)
    depth == max_depth || data.length <= 1
  end

  def self.evaluate_average_e(depths)
    depths.sum(0.0) / depths.length
  end

  def self.evaluate_anomaly_score_s(depths)
    depths.sum
  end
end
