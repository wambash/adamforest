# frozen_string_literal: true

module QuickSort
  def self.split_point(data)
    data.is_a?(Array) ? data.first : data
  end

  def self.decision(element, split)
    element <=> split
  end

  def self.group(data, split)
    { -1 => [], 0 => [], 1 => [] }.merge(data.group_by { |x| x <=> split })
  end

  def self.get_sample(data, batch_size, random: Random)
    data.sample(batch_size, random: random)
  end

  def self.end_condition(data, max_depth)
    data.all? { |x| x == data.first }
  end
end
