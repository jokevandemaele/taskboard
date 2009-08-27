class HashWithIndifferentAccess
  def to_a_with_no_index
    result_array = []
    self.to_a.each {|elem| result_array << elem[1]}
    return result_array
  end
end