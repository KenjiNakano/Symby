class Pow
  def initialize(term, exp)
    @term = term
    @exp = exp
  end

  def self.create(term, exp)
    if exp == Number.new(0)
      return Number.new(1)
    elsif exp == Number.new(1)
      return term
    end
    Pow.new(term, exp)
  end

  def inspect
    "#{self}"
  end

  def to_s
    "(#{@term}**#{@exp})"
  end

  def show
    "(#{@term.show}**#{@exp.show})"
  end

  def expand
    @term * Pow.create(@term, @exp - Number.new(1)).expand
  end

  def simplifiable?
    false
  end
  
  def expandable?
    true
  end

  def diff(target)
    @exp * Pow.create(@term, @exp - Number.new(1))
  end

  def term
    @term
  end

  def exp
    @exp
  end
  
  def *(other)
    if other.instance_of?(Pow)
      if self.term == other.term
        return Pow.create(@term, @exp + other.exp)
      end
    end
    Multiply.create(self, other)
  end

  def debug
    str = "["
    str += "(class:#{self.class})"
    str += "(@exp=#{@exp})"
    str += "(@term=#{@term})"
    str += "]"
    str
  end
end
