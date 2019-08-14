class Quasient
  def self.create(numerator, denominator)
    Quasient.new(numerator, denominator)
  end

  def initialize(numerator, denominator)
    @numerator = numerator
    @denominator = denominator
  end

  def diff(target)
    numerator = @numerator.diff(target)*@denominator - @numerator*@denominator.diff(target)
    denominator = pow(@denominator, Number.new(2))
    Quasient.create(numerator, denominator)
  end

  def to_s
    "(#{@numerator.show}/#{@denominator.show})"
  end

  def inspect
    to_s
  end

  def simplifiable?
    false
  end

  def show
    to_s
  end
end
