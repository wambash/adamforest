# frozen_string_literal: true

require_relative "adamforest/version"

module AdamForest

  class INode
    
    def initialize(left, right, splitPoint)
      @left = left
      @right = right
      @splitPoint = splitPoint
    end

    attr_reader :left,:right,:splitPoint

    def self.getMinMax(data)
      min = data.min()
      max = data.max()
      [min, max]
    end

    def self.getRandomValue(*args)
      return rand(args[0]..args[1])
    end

    def self.initFromData(data)
      return self.new(nil, nil, self.getRandomValue(*self.getMinMax(data)))
    end

  end
  
  # given data, perform filtration with current node and return new data
  def nodeGroupBy(splitPoint)
    group_by{|x| x < splitPoint }
  end

  def add(a,b)
    a + b
  end
end
