# frozen_string_literal: true

module QuickSort

class QuickSort

  def split_point(data)
    data.is_a?(Array) ? data.first : data
  end

  def decision(element, split)
    element <=> split
  end

  def group(data, split)
    { -1 => [], 0 => [], 1 => [] }.merge(data.group_by { |x| x <=> split })
  end

  def get_sample(data, _)
    data
  end

  def end_condition(data)
    data.all? { |x| x == data.first }
  end
end

end
