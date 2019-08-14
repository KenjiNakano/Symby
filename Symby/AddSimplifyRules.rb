class AddSimplifyRules
  def self.make_addsimplify_rule
    rules = []
    #a:addinstance
    rules.push([->(a) {a.only_number?}, ->(a) {a.number}])
    rules.push([->(a) {a.only_one_variable?}, ->(a) {a.first_variable}])
    rules.push([->(a) {a.any_term_simplifiable?},
                ->(a) {a.simplify_each_term}])
    rules.push([->(a) {a.addible_terms_exist?},
                ->(a) {a.add_each_terms}])
    rules.push([->(a) {a.more_than_one_number_exists?},
                ->(a) {a.calc_numbers}])
    return rules
  end

  def self.simplifiable?(addinstance)
    rules = AddSimplifyRules.make_addsimplify_rule
    rules.each{ |r|
      if r[0].call(addinstance)
        return true
      end
    }
    return false
  end

  def self.simplify(addinstance)
    rules = make_addsimplify_rule
    #i = 0
    rules.each{ |r|
      if r[0].call(addinstance)
        #p "AddSimplifyRules:index=#{i}"
        return r[1].call(addinstance)
      end
      #i += 1
    }
    #p "AddSimplifyRules:index=#{i}"
    return addinstance
  end
end
