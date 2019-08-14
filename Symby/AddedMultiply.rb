class AddedMultiply
  def initialize(multiplyterms_array)
    @terms_array = multiplyterms_array
  end

  def simplifiable?
    degree = @terms_array.map{ |a| a.to_degree }
    if degree.uniq.count < degree.count
      return true
    end
    return false
  end

  def accept(multiplyterm)
    find_addible_term  = false
    result  = []
    @terms_array.each{ |t|
      if find_addible_term == false and t.addible?(multiplyterm)
        result.push(t.add(multiplyterm))
        find_addible_term = true
      else
        result.push(t)
      end
    }
    if find_addible_term == false
      result.push(multiplyterm)
    end
    AddedMultiply.new(result)
  end

  def simplify
    if @terms_array.count > 1
      first = @terms_array[0]
      rest = AddedMultiply.new(@terms_array[1..-1])
      return rest.accept(first)
    end
    return self
  end

  def break_down
    @terms_array
  end

  def to_add
    Add.create(self.break_down)
  end

  def show
    str = ""
    #p "self.break_down=#{self.break_down}"
    self.break_down.sort.each{ |e|
      if e.show != ""
        str += e.show + " + "
      end
    }
    srt = str[0..-4]
    #p "str=#{str}"
    return str
  end
end
