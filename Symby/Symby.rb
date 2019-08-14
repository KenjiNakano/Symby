require './Number'
require './Variable'
require './AddSimplifyRules'
require './MultiplyExpandRules'
require './MultiplySimplifyRules'
require './Multiply'
require './Trigonometric'
require './Pow'
require './Add'
#require './AddedMultiply'
require './Quasient'
require './Polynomial'

def pow(term, exp)
  raise "assert" unless exp.instance_of?(Number)
  Pow.create(term, exp)
end


class Machine
  def initialize(expression)
    @expression = expression
    #p "Machine:expression=#{@expression}"
  end

  def run
    p "******** RUN START ********"
    p "<<#{@expression.show}>>"
    expand
    simplify
    p "<<#{@expression.show}>>"
    p "******** RUN END ********"
  end

  def diff(target)
    p "===Diff==="
    p "<<#{@expression.show}>> is differenciated by <<#{target}>>"
    @expression = @expression.diff(target)
    p "--> <<#{@expression.show}>>"
    simplify
    #p "******** DIFF END ********"
    #p @expression.debug
    @expression
  end

  def expand
    p "===Expand==="
    p "<<#{@expression.show}>>"""
    #p @expression.debug
    while @expression.expandable?
      @expression = @expression.expand
      p "<<#{@expression.show}>>"
      #p @expression.debug
    end
    #p "===End Expand==="
    p "--> <<#{@expression.show}>>"
    @expression
  end

  def simplify
    p "===Simplify==="
    p "<<#{@expression.show}>>"
    #p @expression.debug
    while @expression.simplifiable?
      @expression = @expression.simplify
      #p "<<#{@expression.show}>>"
    end
    #p "===End Simplify==="
    p "--> <<#{@expression.show}>>"
    @expression
  end
end

def expand(exp)
  m = Machine.new(exp)
  m.expand
end

def simplify(exp)
  m = Machine.new(exp)
  m.simplify
end

def diff(exp, target)
  m = Machine.new(exp)
  m.diff(target)
end

two = Number.new(2)
three = Number.new(3)
addtwothree = two + three
five = Number.new(5)

a = Variable.new("a")
b = Variable.new("b")
c = Variable.new("c")

#f = Multiply.new(addtwothree, five, Add.new(b, c), Add.new(c, a))
f = addtwothree * five * (b + c) * (c + a)
simplify(expand(f))

x = Variable.new("x")
f = (x + Number.new(1) + Number.new(2)) * pow(x, Number.new(2)) * Number.new(3)
simplify(expand(f))

y = Variable.new("y")
f = pow(x + y, Number.new(2))
simplify(expand(f))

df = diff(f, x)
p df.show
ddf = diff(df, x)
p ddf.show

g = f * f
dg = diff(g, y)

f = x*sin(x)
df = diff(f, x)
ddf = diff(df, x)

f = tan(x)
df = diff(f, x)
