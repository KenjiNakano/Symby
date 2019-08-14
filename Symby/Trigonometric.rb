def sin(exp)
  Sin.create(exp)
end

def cos(exp)
  Cos.create(exp)
end

def tan(exp)
  Tan.create(exp)
end

class Sin
  def self.create(exp)
    Sin.new(exp)
  end

  def initialize(exp)
    @exp = exp
  end

  def show
    to_s
  end

  def to_s
    "sin(#{@exp.show})"
  end

  def inspect
    to_s
  end

  def diff(target)
    Cos.create(@exp)*(@exp.diff(target))
  end

  def simplifiable?
    false
  end

  def expandable?
    false
  end

  def polynomial?
    false
  end

  def *(other)
    Multiply.create(self, other)
  end

  def <=>(other)
    0
  end

  def debug
    str = "["
    str += "(class:#{self.class})"
    str += "(@exp=#{@exp.debug})"
    str += "]"
    str
  end

end

class Cos
  def self.create(exp)
    Cos.new(exp)
  end

  def <=>(other)
    0
  end

  def initialize(exp)
    @exp = exp
  end

  def *(other)
    Multiply.create(self, other)
  end

  def diff(target)
    Number.new(-1)*Sin.create(@exp)*(@exp.diff(target))
  end

  def polynomial?
    false
  end

  def show
    to_s
  end

  def to_s
    "cos(#{@exp.show})"
  end

  def inspect
    to_s
  end

  def simplifiable?
    false
  end

  def debug
    str = "["
    str += "(class:#{self.class})"
    str += "(@exp=#{@exp.debug})"
    str += "]"
    str
  end

end

class Tan
  def self.create(exp)
    Tan.new(exp)
  end

  def show
    "tan(#{@exp.show})"
  end

  def polynomial?
    false
  end
  
  def initialize(exp)
    @exp = exp
  end

  def diff(target)
    Quasient.create(sin(@exp), cos(@exp)).diff(target)
  end

   def debug
    str = "["
    str += "(class:#{self.class})"
    str += "(@exp=#{@exp.debug})"
    str += "]"
    str
  end

end
