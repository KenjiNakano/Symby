class DifferenciateRule

  def self.defrule(pattern, result)
    Rule.new(pattern, result)
  end

  class Pattern
    def initialize(pattern_variable)
      @pat_var = pattern_variable
    end
  end

  def self.create_rules()
    rules = []

    c = :constant
    x = variable(:x)
    y = variable(:y)
    u = function_of(x)
    v = function_of(x)

    diff_target_variable = x

    match(expression) do
      with(c) do
        0
      end
      with(x) do
        1
      end
      with(y) do
        0
      end
      with(u + v) do
        diff(u) + diff(v)
      end
      with(u * v) do
        diff(u)*v + u*diff(v)
      end
    end


    pattern = Pattern.new
    pattern.add_pattern_variables(c, x)
    pattern.add("diff(c, x)", "->(){0}")
    pattern.add("diff(x, x)", "->(){1}")

    pattern.add_pattern_variables(y)
    pattern.add("diff(x, y)", "->(){1}")

    u = function_of(x)
    v = function_of(x)
    pattern.add_pattern_variables(u, v)
    pattern.add("diff(u + v, x)", "diff(u, x) + diff(v, x)")

    
    exp = Number.new(1)
    pattern.match?(exp)
    
    rules.push(defrule(pattern_constant, ->{0}))

    pattern_same_variable = Pattern.new(x, x)
    rules.push(defrule(pattern_variable, ->{1}))

    pattern_different_variable = Pattern.new(y, x)
    rules.push(defrule(pattern_different_variable, ->{0}))

    pattern_add_function = Pattern.new(u + v)
    rules.push(defrule(pattern_add_function, ))
  end

  def self.diff(function, variable)
    rules = make_differenciate_rule
    rules.each{ |r|
      if r.match?(function, variable)
        return r.apply(function, variable)
      end
    }
  end

  class Rule
    def initialize(pattern, result)
      @pattern = Pattern.new(pattern)
      @result = Result.new(result)
    end

    def match?(function, variable)
      if @pattern.match?(function, variable)
        true
      else
        false
      end
    end

    def apply(function, variable)
      
    end
  end
end
