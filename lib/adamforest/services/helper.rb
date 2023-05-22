# frozen_string_literal: true

module Helper
  SplitPointD = Data.define(:split_point, :dimension)

  def self.forest_count_split_point(data)
    dimension = data[0].length
    random_dimension = rand(0...dimension)
    min, max = data.flat_map { |x| x[random_dimension] }.minmax
    SplitPointD.new(rand(min..max), random_dimension)
  end

  def self.element_decision(element, split_point_d)
    element[split_point_d.dimension] < split_point_d.split_point
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
end
