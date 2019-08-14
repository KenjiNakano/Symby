class Polynomial
  def self.create(*args)
    Polynomial.new(*args)
  end

  def initialize(*args)
    @variables = []
    @multiplies = []
    @num = Number.new(0)
    accept(*args)
  end

  def polynomial?
    true
  end

  def terms
    @variables + @multiplies + [@num]
  end

  def accept(term)
    if term.instance_of?(Array)
      term.each{|t| accept(t)}
    elsif term.instance_of?(Add)
      term.terms.each{ |t|
        if t.polynomial?
          accept(t)
        end
      }
    elsif term.instance_of?(Polynomial)
      term.terms.each{ |t| accept(t) }
    else
      if term.instance_of?(Number)
        @num = @num + term
      elsif term.instance_of?(Variable)
        @variables.push(term)
      elsif term.instance_of?(Multiply)
        @multiplies.push(term)
      end
    end
  end

  def not_multiply_terms
    @variables + [@num]
  end

  def expand_multi(multiplied)
    Add.create(self.terms.map{ |a| Multiply.create(a, multiplied) })
  end

  def expandable?
    self.terms.any?{|a| a.expandable? }
  end

  def only_number?
    @multiplies.count == 0 and @variables.count == 0
  end

  def only_one_variable?
    @multiplies.count == 0 and @num == Number.new(0) and @variables.count == 1
  end

  def any_term_simplifiable?
    self.terms.any?{ |a| a.simplifiable? }
  end

  def simplify_each_term
    #p "simplify:self.terms=#{self.terms}"
    Add.create(self.terms.map{ |a| a.simplify })
  end

  def expand
    Add.create(self.terms.map{ |a| a.expand })
  end

=begin
  def multiply_terms_simplifiable?
    addedmul, rest = extract_addmultiply_terms
    addedmul.simplifiable?
  end

  def simplify_in_multiply_terms
    addedmul, rest = extract_addmultiply_terms
    return Add.create(addedmul.simplify.to_add, rest)
  end

  def extract_addmultiply_terms
    [AddedMultiply.new(@multiplies), self.not_multiply_terms]
  end
=end
  def more_than_one_number_exists?
    self.terms.select{ |a| a.instance_of?(Number) }.count >= 2
  end

  def number
    @num
  end

  def simplifiable?
    false
  end

  def diff(target)
    Add.create(terms.map{ |t| t.diff(target) })
  end

  #display
  def show
    str = "("
    if @multiplies.count >= 1
      @multiplies.each{ |m|
        str += m.show + " + "
      }
    end

    if @variables.count >= 1
      @variables.each{ |v|
        str += v.show + " + "
      }
    end

    if @num == Number.new(0)
      str = str[0..-4]
    elsif
      str += @num.show
    end

    str += ")"
    return str
  end

  def to_s
    show
  end

  def inspect
    show
  end

  def debug
    str = "["
    str += "(class:#{self.class})"
    str += "(@multiplies=#{@multiplies})"
    str += "(@variables=#{@variables})"
    str += "(@num=#{@num.debug})"
    str += "]"
    str
  end

end
