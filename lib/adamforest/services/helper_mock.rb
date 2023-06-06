# frozen_string_literal: true

module HelperMock
  def self.split_point(data)
    min, max = data.flat_map { |x| x[0] }.minmax
    (min + max) / 2.0
  end

  DataPoint = Data.define(:depth, :data)

  def self.decision_function(sp)
    ->(x) { x[0] < sp }
  end

  def self.decision(element, split_point_d)
    decision_function(split_point_d).call(element)
  end

  def self.group(data, split_point)
    { true => [], false => [] }.merge(data.group_by(&decision_function(split_point)))
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
