# frozen_string_literal: true

require "test_helper"

class TestAdamforest < Minitest::Test
  include AdamForest
  def test_that_it_has_a_version_number
    refute_nil ::Adamforest::VERSION
  end

  def test_node_created
    node = InNode.new(nil, nil, 3)
    assert_nil node.left
    assert_nil node.right
    assert_equal node.split_point, 3
  end

  def test_init_from_data
    helper_mock = Class.new do
      def self.forest_count_split_point(data)
        (data.min + data.max) / 2.0
      end

      def self.node_group_by(data, split_point)
        data.group_by { |x| x < split_point }
      end
    end

    node = Node.init_from_data([1, 2, 3], helper_mock)
    assert_equal node.to_a, [[1], [[2], [3]]]
    # assert_equal node.splitPoint, 3
  end

  def test_node_group_by
    grouped = ForestHelperService.node_group_by([1, 2, 3, 4], 3)
    assert_equal grouped[true], [1, 2]
  end

  def test_dimensional_group_by
    splitD = SplitPointD.new(7, 1)
    res = ForestHelperServiceDimensional.node_group_by([[2, 2], [3, 3], [7, 8]], splitD)
    assert_equal res[false], [[7,8]]
  end
end
