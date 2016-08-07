module PrimitiveValue
  def ==(target)
    @value == target.value
  end

  def to_s
    @value.to_s
  end

  def eval(env)
    self
  end

end

class IntVal
  include PrimitiveValue
  attr_reader :value

  def initialize(value)
    @value = value
  end
end

class Variable
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def eval(env)
    env.lookup_var(@symbol)
  end
end

class Lambda
  attr_reader :params, :body

  def initialize(params, body)
    @params = params
    @body = body
  end

  def eval(env)
    self
  end

  def apply(env, *args)
    lifted_args = args.map{|arg| arg.kind_of?(Fixnum) ? IntVal.new(arg) : arg}
    params_with_args = @params.zip(lifted_args.map{|arg| arg.eval(env)})
    new_env = env.extend(Hash[*params_with_args.flatten])
    @body.eval(new_env)
  end
end

class Let
  attr_reader :var_defs, :body

  def initialize(var_defs, body)
    @var_defs = var_defs
    @body = body
  end

  def eval(env)
    params = @var_defs.map{|var_def| var_def[0]}
    args = @var_defs.map{|var_def| var_def[1]}
    Lambda.new(params, @body).apply(env, *args)
  end
end

class Func
  attr_reader :symbol, :value

  def initialize(symbol, value)
    @symbol = symbol
    @value = value
  end

  def eval(env)
    body = env.lookup_var(@symbol)
    body.apply(env, @value)
  end
end

module BinaryOperator
  def eval(env)
    to_eval_func = lambda{|val| 
      if val.kind_of?(Symbol) then
        Variable.new(val)
      elsif val.kind_of?(Fixnum)
        IntVal.new(val)
      else
        val
      end
    }
    l = to_eval_func.call(@left)
    r = to_eval_func.call(@right)
    [l.eval(env), r.eval(env)]
  end
end

class AddOp
  include BinaryOperator
  attr_reader :value

  def initialize(left, right)
    @left = left
    @right = right
  end

  def eval(env)
    lval, rval = super(env)
    IntVal.new(lval.value + rval.value)
  end
end

class SubOp
  include BinaryOperator
  attr_reader :value

  def initialize(left, right)
    @left = left
    @right = right
  end

  def eval(env)
    lval, rval = super(env)
    IntVal.new(lval.value - rval.value)
  end
end

class MulOp
  include BinaryOperator
  attr_reader :value

  def initialize(left, right)
    @left = left
    @right = right
  end

  def eval(env)
    lval, rval = super(env)
    IntVal.new(lval.value * rval.value)
  end
end

