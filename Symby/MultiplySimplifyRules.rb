class MultiplySimplifyRules
  def self.simplifiable?(mulinstance)
    rules = create_multiply_simplify_rule
    rules.each{ |r|
      if r[0].call(mulinstance)
        return true
      end
    }
    return false
  end

  def self.simplify(mulinstance)
    rules = create_multiply_simplify_rule
    rules.each{ |r|
      if r[0].call(mulinstance)
        return r[1].call(mulinstance)
      end
    }
    return mulinstance
  end

  def self.create_multiply_simplify_rule
    rules = []
    #m:instance of Multiply
    rules.push([->(m){ m.include_zero? }, ->(m){ m.to_zero}])
    rules.push([->(m) { m.only_number? }, ->(m){ m.to_number }])
#    rules.push([->(m) { m.include_pow? }, ->(m){ m.expand_pow }])
    rules.push([->(m) {m.any_factor_simplifiable?},
                ->(m) {m.simplify_each_term}])
    return rules
  end
end
