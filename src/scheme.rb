$global_env = [$primitive_fun_env, $boolean_env]

$primitive_fun_env = {
  :+ => [:prim, lambda{|x, y| x + y}],
  :- => [:prim, lambda{|x, y| x - y}],
  :* => [:prim, lambda{|x, y| x * y}],
  :> => [:prim, lambda{|x, y| x > y}],
  :>= => [:prim, lambda{|x, y| x >= y}],
  :< => [:prim, lambda{|x, y| x < y}],
  :<= => [:prim, lambda{|x, y| x <= y}],
  :== => [:prim, lambda{|x, y| x == y}],
}

$boolean_env = {true: true, false: false}

def _eval(exp, env)
  # not list(数値 or 変数)のとき
  if not list?(exp)
    if immediate_val?(exp)
      exp
    else
      # 環境から変数の値を取得
      lookup_var(exp, env)
    end
  else
    # special_form(組み込み関数ではない特殊な形)
    if special_form?(exp)
      eval_special_form(exp, env)
    # 組み込み関数評価
    else
      fun = _eval(car(exp), env)
      args = eval_list(cdr(exp), env)
      apply(fun, args)
    end
  end
end

# 型判別
def list?(exp)
  exp.is_a?(Array)
end

def immediate_val?(exp)
  num?(exp)
end

def num?(exp)
  exp.is_a?(Numeric)
end

# 環境から変数の値を取得
def lookup_var(var, env)
  alist = env.find{|alist| alist.key?(var)}
  if alist.nil?
    raise "couldn't find value to variavles:'#{var}'"
  end
  alist[var]
end

def special_form?(exp)
  lambda?(exp) or 
    let?(exp) or
    letrec?(exp) or
    if?(exp)
end

# special_form判別
def lambda?(exp)
  exp[0] == :lambda
end

def let?(exp)
  exp[0] == :let
end

def letrec?(exp)
  exp[0] == :letrec
end


def if?(exp)
  exp[0] == :if
end

def eval_special_form(exp, env)
  if lambda?(exp)
    eval_lambda(exp, env)
  elsif let?(exp)
    eval_let(exp, env)
  elsif letrec?(exp)
    eval_lectrec(exp, env)
  elsif if?(exp)
    eval_if(exp, env)
  end
end

# list操作
def car(list)
  list[0]
end

def cdr(list)
  list[1..-1]
end

def eval_list(exp, env)
  exp.map{|e| _eval(e, env)}
end
def apply(fun, args)
  if primitive_fun?(fun)
    apply_primitive_fun(fun, args)
  else
    lambda_apply(fun, args)
  end
end

def primitive_fun?(exp)
  exp[0] == :prim
end

def apply_primitive_fun(fun, args)
  fun_val = fun[1]
  fun_val.call(*args)
end

def eval_lambda(exp, env)
  make_closure(exp, env)
end

def make_closure(exp, env)
  parameters, body = exp[1], exp[2]
  [:closure, parameters, body, env]
end

# closure + args -> 環境を拡張 -> eval(body, new_env)
def lambda_apply(closure, args)
  parameters, body, env = closure_to_parameters_body_env(closure)
  new_env = extend_env(parameters, args, env)
  _eval(body, new_env)
end

def closure_to_parameters_body_env(closure)
  [closure[1], closure[2], closure[3]]
end

def extend_env(parameters, args, env)
  alist = parameters.zip(args)
  h = Hash.new
  alist.each{|k, v| h[k] = v }
  [h] + env
end

# let -> lambda + args -> eval(lambda)
def eval_let(exp, env)
  parameters, args, body = let_to_parameters_args_body(exp)
  new_exp = [[:lambda, parameters, body]] + args
  _eval(new_exp, env)
end

def let_to_parameters_args_body(exp)
  [exp[1].map{|e| e[0]}, exp[1].map{|e| e[1]}, exp[2]]
end

def eval_if(exp, env)
  cond, true_clause, false_clause = if_to_cond_true_false(exp)
  if _eval(cond, env)
    _eval(true_clause, env)
  else
    _eval(false_clause, env)
  end
end

def if_to_cond_true_false(exp)
  [exp[1], exp[2], exp[3]]
end












