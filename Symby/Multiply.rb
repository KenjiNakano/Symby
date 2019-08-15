class Multiply

  def self.create(*args)
    if args.map{ |a| a.instance_of?(Number) }.select{ |a| a == Number.new(0) }.count >= 1
      return Number.new(0)
    elsif args.all?{ |a| a.instance_of?(Number) }
      return args.reduce(:*)
    end

    Multiply.new(args)
  end

  def initialize(*args)
    #p "Multiply:args=#{args}"
    @coefficient = Number.new(1)
    @variables = []

    args.each{ |a|
      accept(a)
    }
  end

  def accept(factor)
    if factor.instance_of?(Array)
      factor.each{ |f| accept(f) }
    elsif factor.instance_of?(Multiply)
      factor.factors.each{ |f| accept(f) }
    else
      if factor.instance_of?(Number)
        @coefficient = @coefficient * factor
      else
        @variables.push(factor)
      end
    end
  end

  def factors
    [@coefficient] + @variables
  end

  def *(other)
    Multiply.create(self, other)
  end

  def +(other)
    if other.instance_of?(Multiply)
      if self.addible?(other)
        return self.add(other)
      end
    end
    Add.create(self, other)
  end

  def debug
    str = "["
    str += "(class:#{self.class})"
    str += "(@coefficient=#{@coefficient})"
    @variables.each{ |f|
      str += "(@variables=" + f.debug + ")"
    }
    str += "]"
    str
  end

  def addible?(multiplyinstance)
    self.to_degree == multiplyinstance.to_degree
  end

  def add(multiplyinstance)
    newCoefficient = self.coefficient + multiplyinstance.coefficient
    newCoefficient * @variables
  end

  def <=>(other_mul_instance)
    #takai jisuu wo yusen suruga
    #jisuu ga onaji tokiha alphabet jun ni narabu youni suru
    c = self.jisuu <=> other_mul_instance.jisuu
    if c != 0
      return c*(-1)
    end

    (self.to_ordered_factor <=> other_mul_instance.to_ordered_factor)
  end

  def diff(target)
    #p "Multiply:diff:@coefficient=#{@coefficient}, @variables=#{@variables}"
    if @variables.count == 0
      return Number.new(0)
    end

    if @variables.count == 1
      first = @variables.first
      return @coefficient * first.diff(target)
    end

    first = @variables.first
    rest = Multiply.create(@variables.drop(1))
    @coefficient * (first.diff(target) * rest + first * rest.diff(target))
  end

  def -(other)
    Add.create(self, Number.new(-1)*other)
  end

  def coefficient
    @coefficient
  end

  def jisuu
    @variables.count
  end

  def to_ordered_factor
    addpart = @variables.select{ |e| e.instance_of?(Add) }
    notaddpart = @variables.reject{ |e| e.instance_of?(Add) }
    notaddpart.sort.join("") + addpart.join("")
  end


  def inspect
    "#{self}"
  end

  def to_s
    "(" + self.factors.join("*")  + ")"
  end

  def show
    if @coefficient == Number.new(0) 
      return @coefficient.to_s
    end

    arr = []
    if coefficient_show != ""
      arr.push(coefficient_show)
    end

    if variables_show != ""
      arr.push(variables_show)
    end

    return arr.join("*")
  end

  def coefficient_show
    if @coefficient == Number.new(1)
      return ""
    end
    return @coefficient.show
  end

  def variables_show
    arr = []
    variables = @variables
    if variables.count >= 1
      vuniq = variables.uniq
      vuniq.each{ |v|
        cnt = variables.select{ |f| f == v }.count
        if cnt == 1
          arr.push(v.show)
          #str += "#{v}*"
        else
          arr.push("(#{v.show}**#{cnt})")
          #str += "(#{v}**#{cnt})*"
        end
      }
    end
    return arr.join("*")
  end

  def expandable?
    MultiplyExpandRules.expandable?(self)
  end

  def expand
    MultiplyExpandRules.expand(self)
  end

  def pow_exists?
    @variables.any?{ |a| a.instance_of?(Pow) }
  end

  def expand_pow
    pow, rest = self.find_first_pow
    Multiply.create(pow.expand, rest)
  end

  def add_exists?
    @variables.any?{ |a| a.instance_of?(Add) }
  end

  def expand_add
    add, rest = self.find_first_add
    add.expand_multi(rest)
  end

  def polynomial?
    @variables.all?{ |v| v.polynomial? }
  end

  def find_first_add
    add_array = @variables.select{ |a| a.instance_of?(Add)}
    not_add_array = @variables.reject{ |a| a.instance_of?(Add)}
    return [add_array.first, Multiply.create(add_array.drop(1) + not_add_array, @coefficient)]
  end

  def find_first_pow
    pow_array = @variables.select{ |a| a.instance_of?(Pow)}
    not_pow_array = @variables.reject{ |a| a.instance_of?(Pow)}
    return [pow_array.first, Multiply.create(pow_array.drop(1) + not_pow_array, @coefficient)]
  end

  def simplifiable?
    MultiplySimplifyRules.simplifiable?(self)
  end

  def simplify
    MultiplySimplifyRules.simplify(self)
  end

  def include_zero?
    @coefficient == Number.new(0)
  end

  def to_zero
    Number.new(0)
  end

  def only_number?
    @variables.count == 0
  end

  def to_number
    @coefficient
  end

  def any_factor_simplifiable?
    #p self.debug
    self.factors.any?{|f| f.simplifiable?}
  end

  def simplify_each_term
    Multiply.create(self.factors.map{ |f| f.simplify })
  end

  def to_degree
    h = {}
    @variables.uniq.each{ |v|
      h[v] = @variables.select{ |f| f == v }.count
    }
    return h
  end
end
