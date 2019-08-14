class Variable
  def initialize(name)
    @name = name
  end

  def polynomial?
    true
  end

  def inspect
    "#{self}"
  end

  def to_s
    "#{@name}"
  end

  def +(other)
    Add.create(self, other)
  end

  def expandable?
    false
  end

  def expand
    self
  end

  def name
    @name
  end

  def <=>(other)
    if other.instance_of?(Variable)
      @name <=> other.name
    elsif other.instance_of?(Number)
      1
    else
      0
    end
  end

  def ==(other_variable)
    if other_variable.instance_of?(Variable)
      return @name == other_variable.name
    end
    false
  end

  def diff(target)
    if self == target
      return Number.new(1)
    else
      return Number.new(0)
    end
  end

  def show
    self.to_s
  end

  def simplifiable?
    false
  end

  def simplify
    self
  end

  def *(other)
    Multiply.create(self, other)
  end

  def debug
    str = "["
    str += "(class:#{self.class})"
    str += "(@name=#{@name})"
    str += "]"
    str
  end
end
