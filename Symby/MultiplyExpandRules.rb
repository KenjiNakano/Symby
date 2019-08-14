class MultiplyExpandRules
  def self.expandable?(mulinstance)
    rules = create_multiply_expand_rule
    rules.each{ |r|
      if r[0].call(mulinstance)
        return true
      end
    }
    return false
  end

  def self.expand(mulinstance)
    rules = create_multiply_expand_rule
    rules.each{ |r|
      if r[0].call(mulinstance)
        return r[1].call(mulinstance)
      end
    }
    return mulinstance
  end

  def self.create_multiply_expand_rule
    rules = []
    rules.push([->(mulinstance) { mulinstance.pow_exists? }, ->(mulinstance){ mulinstance.expand_pow }])
    rules.push([->(mulinstance) { mulinstance.add_exists? }, ->(mulinstance){ mulinstance.expand_add }])
    return rules
  end

end
