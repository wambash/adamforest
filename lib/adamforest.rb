# frozen_string_literal: true

require_relative "adamforest/version"

module AdamForest
  class Node
    def self.init_from_data(data, forest_helper = ForestHelperService)
      return OutNode.new(data) if data.nil? || data.length <= 1

      split_point = forest_helper.forest_count_split_point(data)
      left_group, right_group = forest_helper.node_group_by(data, split_point).values_at(true, false)
      InNode.new(
        init_from_data(left_group, forest_helper),
        init_from_data(right_group, forest_helper),
        split_point
      )
    end
  end

  class OutNode
    def initialize(data)
      @data = data
    end

    attr_reader :data

    def to_j
      @data
    end

    def to_a
      @data
    end
  end

  class InNode
    def initialize(left, right, split_point)
      @left = left
      @right = right
      @split_point = split_point
    end

    attr_reader :left, :right, :split_point

    def to_j
      { "left": @left.to_j, "right": @right.to_j, "SP": @split_point.to_j }
    end

    def to_a
      [@left.to_a, @right.to_a]
    end
  end

  class ForestHelperService
    def self.forest_count_split_point(data)
      min, max = data.minmax
      rand(min..max)
    end

    def self.node_group_by(data, split_point)
      data.group_by { |x| x < split_point }
    end
  end

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

  class ForestHelperServiceDimensional
    def self.forest_count_split_point(data)
      dimension = data[0].kind_of?(Array) ? data[0].length : ForestHelperService.forest_count_split_point(data)
      random_dimension = rand(0...dimension)
      SplitPointD.new(data.map { |x| x[random_dimension] }.sample, random_dimension)
    end

    def self.node_group_by(data, split_point_d)
      data.group_by { |x| x[split_point_d.dimension] < split_point_d.split_point }
    end
  end
end
