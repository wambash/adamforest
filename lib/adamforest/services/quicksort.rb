# frozen_string_literal: true

module QuickSort
  def self.forest_count_split_point(data)
    data.is_a?(Array) ? data.first : data
  end

  def self.get_data_decision(data)
    sp = forest_count_split_point(data)

    ->(x) { x <=> sp }
  end

  def self.get_node_groups(data, decision_fun: get_data_decision(data))
    { -1 => [], 0 => [], 1 => [] }.merge(data.group_by(&decision_fun))
  end

  def self.get_sample(data, batch_size, random: Random)
    data.sample(batch_size, random: random)
  end

  def self.end_condition(data, max_depth)
    data.all? { |x| x == data.first }
  end
end