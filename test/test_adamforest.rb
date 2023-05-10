# frozen_string_literal: true

require "test_helper"
include AdamForest

class TestAdamforest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Adamforest::VERSION
  end

  def test_node_created
    node = InNode.new(nil, nil, 3)
    assert_nil node.left
    assert_nil node.right
    assert_equal node.splitPoint, 3
  end

  def test_initFromData  

    helperMock = Class.new do
      def self.forestCountSplitPoint(data)
        (data.min + data.max)/2.0
      end

      def self.nodeGroupBy(data, splitPoint)
        data.group_by{ |x| x < splitPoint }
      end
    end

    node = Node.initFromData([1,2,3], helperMock)
    assert_equal node.to_a, [[1], [[2], [3]]]
    #assert_equal node.splitPoint, 3
  end

  def test_node_groupBy
    grouped = ForestHelperService.nodeGroupBy([1,2,3,4], 3)
    assert_equal grouped[true], [1,2]
  end

end
