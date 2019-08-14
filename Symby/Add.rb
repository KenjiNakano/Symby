class Add
  #initializing
  def self.create(*args)
    if args.all?{ |a| a.instance_of?(Number) }
      return args.reduce(:+)
    end

    Add.new(*args)
  end

  def initialize(*args)
    #p "Add:args=#{args}"
    @terms = []
    args.each{ |a|
      accept(a)
    }
    #p "Add:@terms=#{@terms}"
  end

  def accept(term)
    #p "Add.accept:term=#{term}"
    if term.instance_of?(Array)
      term.each{ |t| accept(t) }
    elsif term.instance_of?(Add)
      term.terms.each{ |t| accept(t) }
    elsif term.instance_of?(Polynomial)
      term.terms.each{ |t| accept(t) }
    else
      @terms.push(term)
    end
  end

  #operator
  def +(other)
    Add.create(self, other)
  end

  def *(other)
    Multiply.create(self, other)
  end

  def <=>(other)
    self.terms.count <=> other.terms.count
  end

  #property
  def terms
    @terms
    #[@poly] + @non_poly_terms
  end

  def polynomial?
    @terms.all?{ |t| t.polynomial? }
    # @non_poly_terms.count == 0
  end

  def poly
    Polynomial.create(self)
  end

  def only_number?
    self.polynomial? and poly.only_number?
    #self.polynomial? and @poly.only_number?
  end

  def number
    poly.number
  end

  def only_one_variable?
    self.polynomial? and poly.only_one_variable?
  end

  def first_variable
    poly.first_variable
  end

  def diff(target)
    #p self.debug
    Add.create(terms.map{ |t| t.diff(target) })
    #p "retval=#{retval.debug}"
  end

  def expandable?
    self.terms.any?{|a| a.expandable? }
  end

  def expand_multi(multiplied)
    # @poly.expand_multi(multiplied)
    Add.create(self.terms.map{ |t| Multiply.create(t, multiplied) })
  end

  def expand
    Add.create(self.terms.map{ |a| a.expand })
  end

  def simplifiable?
    AddSimplifyRules.simplifiable?(self)
  end

  def simplify
    AddSimplifyRules.simplify(self)
  end

  def any_term_simplifiable?
    @terms.any?{|a| a.simplifiable?}
  end

  def simplify_each_term
    Add.new(@terms.map{ |a| a.simplify })
  end

  def addible_terms_exist?
    addible_terms_exist_core?(@terms)
  end

  def addible_terms_exist_core?(terms)
    if terms.count == 1
      return false
    else
      first = terms.first
      rest = terms.drop(1)
      rest.each{ |r|
        if not (r + first).instance_of?(Add)
          return true
        end
      }
      return addible_terms_exist_core?(rest)
    end
  end

  def add_each_terms
    add_each_terms_core(@terms)
  end

  def add_each_terms_core(terms)
    #p "terms=#{terms}"
    if terms.count == 1
      return terms.first
    else
      first = terms.first
      rest = terms.drop(1)
      newrest = []
      added = false

      rest.each{ |r|
        if added == false and not (r + first).instance_of?(Add)
          newrest.push(r + first)
          added = true
        else
          newrest.push(r)
        end
      }

      if added == true
        return add_each_terms_core(newrest)
      else
        return first + add_each_terms_core(newrest)
      end
    end
  end
=begin
  def simplify_in_multiply_terms
    @poly.simplify_in_multiply_terms
  end

  def extract_addmultiply_terms
    @poly.extract_addmultiply_terms
  end
=end
  def more_than_one_number_exists?
    self.poly.more_than_one_number_exists?
  end

  #display
  def inspect
    "#{self}"
  end

  def to_s
    "(" + self.terms.join(" + ") + ")"
  end

  def show
    "(" + self.terms.map{|t| t.show}.join(" + ") + ")"
  end

  def debug
    str = "["
    str += "(class:#{self.class})"
    str += "(@terms="
    @terms.each{ |t|
      str += "(#{t.debug})"
    }
    str += ")"
    str += "]"
    str
  end

end
