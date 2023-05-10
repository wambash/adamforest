# frozen_string_literal: true

require_relative "adamforest/version"

module AdamForest
  class Node
    def self.initFromData(data, fh = ForestHelperService)
      return OutNode.new(data) if data.nil? || data.length <= 1

      splitPoint = fh.forestCountSplitPoint(data)
      leftGroup, rightGroup = fh.nodeGroupBy(data, splitPoint).values_at(true, false)
      InNode.new(
        self.initFromData(leftGroup, fh),
        self.initFromData(rightGroup, fh),
        splitPoint
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
    def initialize(left, right, splitPoint)
      @left = left
      @right = right
      @splitPoint = splitPoint
    end

    attr_reader :left, :right, :splitPoint

    def to_j
      {"left": @left.to_j, "right": @right.to_j, "SP": @splitPoint}
    end

    def to_a
      [@left.to_a, @right.to_a]
    end
  end


  class Helper
  end

  class ForestHelperService < Helper
    # given data, perform filtration with current node and return new data
    def self.forestCountSplitPoint(data)
      min, max = data.minmax
      rand(min..max)
    end

    def self.nodeGroupBy(data, splitPoint)
      data.group_by{ |x| x < splitPoint }
    end

  end
end
