# frozen_string_literal: true

module HelperMock

DataPoint = Data.define(:depth, :data)

class Mock

  def initialize(max_depth: 16)
    @max_depth = max_depth
  end

  def split_point(data)
    min, max = data.map { |x| x[0] }.minmax
    (min + max) / 2.0
  end

  def decision_function(sp)
    ->(x) { x[0] < sp }
  end

  def decision(element, split_point_d)
    decision_function(split_point_d).call(element)
  end

  def group(data, split_point)
    { true => [], false => [] }.merge(data.group_by(&decision_function(split_point)))
  end

  def get_sample(data, _)
    data
  end

  def end_condition(data)
    data == @max_depth || data.length <= 1
  end
end

end
