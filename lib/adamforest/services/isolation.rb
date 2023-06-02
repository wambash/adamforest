# frozen_string_literal: true

module Isolation
  SplitPointD = Data.define(:split_point, :dimension)

  DataPoint = Data.define(:depth, :data)

  def self.get_sample(data, batch_size, random)
    DataPoint.new(depth: 0, data: data.sample(batch_size))
  end

  def self.forest_count_split_point(data)
    dimension = data[0].length
    random_dimension = rand(0...dimension)
    min, max = data.flat_map { |x| x[random_dimension] }.minmax
    SplitPointD.new(rand(min..max), random_dimension)
  end

  def self.get_data_decision(data_point)
    sp = forest_count_split_point(data_point.data)

    ->(x) { x[sp.dimension] < sp.split_point }
  end

  def self.get_node_groups(data_point, decision_fun: get_data_decision(data_point))
    s = { true => [], false => [] }.merge(data_point.data.group_by(&decision_fun))
    s.transform_values do |group|
      DataPoint.new(depth: data_point.depth + 1, data: group)
    end
  end

  def self.harmonic_number(num)
    Math.log(num) + 0.5772156649
  end

  def self.harmonic_number_approx(num)
    (1...num).map { |x| 1.0 / x }.sum
  end

  def self.evaluate_path_length_c(batch_size)
    return 1 if batch_size == 2
    return 0 if batch_size < 2

    2 * harmonic_number(batch_size - 1) - 2 * (batch_size - 1) / batch_size
  end

  def self.end_condition(data_point, max_depth)
    data_point.depth == max_depth || data_point.data.length <= 1
  end

  # E(h(x)) is the average of h(x) from a collection of iTrees
  def self.evaluate_average_e(depths)
    depths.sum(0.0) / depths.length
  end

  # depths are the depths returned by evalute_forest
  def self.evaluate_anomaly_score_s(depths, batch_size)
    2 ** -(evaluate_average_e(depths) / evaluate_path_length_c(batch_size))
  end
end
