# frozen_string_literal: true

module HelperMock
  def self.forest_count_split_point(data)
    min, max = data.flat_map { |x| x[0] }.minmax
    (min + max) / 2.0
  end

  def self.element_decision(element, split_point)
    element[0] < split_point
  end
end
