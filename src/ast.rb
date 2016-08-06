module AST 
  def eval
    [@left.eval, @right.eval]
  end
end

class IntVal
  include AST
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def eval
    @value
  end
end

class AddOp
  include AST
  attr_reader :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def eval
    lval, rval = super
    lval + rval
  end
end

