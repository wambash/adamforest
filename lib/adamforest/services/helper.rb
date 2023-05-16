# frozen_string_literal: true

module Helper
  class SplitPointD
    def initialize(split_point, dimension)
      @split_point = split_point
      @dimension = dimension
    end

    def to_j
      { "SP": @split_point, "D": @dimension }
    end

    attr_reader :split_point, :dimension
  end

  def self.forest_count_split_point(data)
    dimension = data[0].length
    random_dimension = rand(0...dimension)
    min, max = data.flat_map { |x| x[random_dimension] }.minmax
    SplitPointD.new(rand(min..max), random_dimension)
  end

  def self.element_decision(element, split_point_d)
    element[split_point_d.dimension] < split_point_d.split_point
  end
end
