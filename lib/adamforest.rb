# frozen_string_literal: true

require_relative "adamforest/version"

module AdamForest
  class Node
    def self.init_from_data(data, fh = ForestHelperService)
      return OutNode.new(data) if data.nil? || data.length <= 1

      split_point = fh.forest_count_split_point(data)
      left_group, right_group = fh.node_group_by(data, split_point).values_at(true, false)
      InNode.new(
        init_from_data(left_group, fh),
        init_from_data(right_group, fh),
        split_point
      )
    end
  end

  class OutNode < Node
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

  class InNode < Node
    def initialize(left, right, split_point)
      @left = left
      @right = right
      @split_point = split_point
    end

    attr_reader :left, :right, :split_point

    def to_j
      { "left": @left.to_j, "right": @right.to_j, "SP": @split_point }
    end

    def to_a
      [@left.to_a, @right.to_a]
    end
  end

  class Helper
  end

  class ForestHelperService < Helper
    # given data, perform filtration with current node and return new data
    def self.forest_count_split_point(data)
      min, max = data.minmax
      rand(min..max)
    end

    def self.node_group_by(data, split_point)
      data.group_by { |x| x < split_point }
    end
  end
end
