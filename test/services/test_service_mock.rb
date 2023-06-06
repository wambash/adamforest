# frozen_string_literal: true

require "test_helper"
require "adamforest/services/helper_mock"


class TestServiceMock < Minitest::Test
  include AdamForest

  def test_dimensional_group_by
    data = [[2, 2], [3, 3], [7, 8]]

    split_point = HelperMock.split_point(data)
    res = HelperMock.group(data, split_point)
    assert_equal res[false], [[7, 8]]
  end

end
