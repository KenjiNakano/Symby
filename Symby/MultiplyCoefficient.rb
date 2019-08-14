=begin
class MultiplyCoefficient
  def initialize(numbers_array)
    @numbers_array = numbers_array
    @numbers_array.delete(Number.new(1))
    if @numbers_array.count == 0
      @numbers_array.push(Number.new(1))
    end
  end

  def to_numberarray
    @numbers_array
  end

  def to_s
    @numbers_array.join("*")
  end

  def simplify
    MultiplyCoefficient.new([@numbers_array.reduce(:*)])
  end

  def multi(other_coefficient)
    @numbers_array += other_coefficient.to_numberarray
    @numbers_array.delete(Number.new(1))
    if @numbers_array.count == 0
      @numbers_array.push(Number.new(1))
    end
    return self
  end

  def add(other_coefficient)
    @numbers_array = [@numbers_array.reduce(:*) + other_coefficient.to_numberarray.reduce(:*)]
    return self
  end

  def show
    if self.to_number == Number.new(1)
      return ""
    end
    return self.to_number.to_s + "*"
  end

  def simplifiable?
    @numbers_array.count > 1
  end

  def to_number
    Number.new(@numbers_array.reduce(:*))
  end
end
=end
