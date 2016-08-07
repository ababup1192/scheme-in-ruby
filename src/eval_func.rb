module PrimitiveValue
  def ==(target)
    @value == target.value
  end

  def to_s
    @value.to_s
  end

  def add_env(env)
  end

  def eval
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
  attr_reader :value, :env

  def initialize(symbol, env)
    @symbol = symbol
    @env = env
  end

  def eval
    @env.lookup_var(@symbol)
  end
end

class Lambda
  attr_reader :params, :body, :env

  def initialize(params, body)
    @params = params
    @body = body
  end

  def add_env(env)
    @env = env
  end

  def eval
    self
  end

  def apply(*args)
    @args = args.map{|arg| arg.kind_of?(Fixnum) ? IntVal.new(arg) : arg}
    # params_with_args = @params.zip(lifted_args.map{|arg| arg.eval(env)})
    # new_env = @env.extend(Hash[*params_with_args.flatten])
    # @body.add_env(new_env)
    # @body.eval
    @body
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
  attr_reader :symbol, :value, :env

  def initialize(symbol, value)
    @symbol = symbol
    @value = value
  end

  def add_env(env)
    @env = env
  end

  def eval
    body = @env.lookup_var(@symbol)
    body.apply(value)
  end
end

module BinaryOperator
  def add_env(env)
    @env = env
  end

  def eval
    to_eval_func = lambda{|val| 
      if val.kind_of?(Symbol) then
        Variable.new(val, @env)
      elsif val.kind_of?(Fixnum)
        IntVal.new(val)
      else
        val
      end
    }
    l = to_eval_func.call(@left)
    r = to_eval_func.call(@right)
    [l.eval, r.eval]
  end
end

class AddOp
  include BinaryOperator
  attr_reader :value

  def initialize(left, right)
    @left = left
    @right = right
  end

  def eval
    lval, rval = super
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

  def eval
    lval, rval = super
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

  def eval
    lval, rval = super
    IntVal.new(lval.value * rval.value)
  end
end

