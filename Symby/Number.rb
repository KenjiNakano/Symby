class Number
  def initialize(value)
    @value = value
  end

  def diff(target)
    Number.new(0)
  end

  def polynomial?
    true
  end

  def debug
    str = "["
    str += "(class:#{self.class})"
    str += "(@value=#{@value})"
    str += "]"
    str
  end

  def simplify
    self
  end

  def inspect
    "#{self}"
  end

  def to_s
    "#{@value}"
  end

  def expandable?
    false
  end

  def expand
    self
  end

  def to_value
    @value
  end

  def ==(other)
    @value == other.to_value
  end

  def +(other)
    if other.instance_of?(Number)
      return Number.new(@value + other.to_value)
    end
    Add.create(@value, other)
  end

  def -(other)
    Number.new(@value - other.to_value)
  end

  def *(other)
    if other.instance_of?(Number)
      return Number.new(@value * other.to_value)
    end
    Multiply.create(self, other)
  end

  def /(other)
    Number.new(@value/other.to_value)
  end

  def simplifiable?
    false
  end

  def show
    self.to_s
  end

end

