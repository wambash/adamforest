# frozen_string_literal: true

module HelperMock
  def self.forest_count_split_point(data)
    min, max = data.flat_map { |x| x[0] }.minmax
    (min + max) / 2.0
  end

  DataPoint = Data.define(:depth, :data)

  def self.get_data_decision(data)
    sp = forest_count_split_point(data)

    ->(x) { x[0] < sp }
  end

  def self.get_node_groups(data, decision_fun: get_data_decision(data))
    { true => [], false => [] }.merge(data.group_by(&decision_fun))
  end

  def self.get_sample(data, batch_size, random: Random.new(1))
    data.sample(batch_size, random: random)
  end

  def self.evaluate_path_length_c(_)
    0
  end

  def self.end_condition(data, max_depth)
    data == max_depth || data.length <= 1
  end
end
