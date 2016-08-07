require 'test/unit'
require_relative '../src/environment'
require_relative '../src/eval_func'


class EvalFuncTest < Test::Unit::TestCase
  def test_variable
    env = Environment.new([{x: IntVal.new(5)}])
    expected = IntVal.new(5)
    actual = Variable.new(:x).eval(env)
    assert_equal expected, actual
  end

  def test_addop
    env = Environment.new()
    expected = IntVal.new(10)
    actual = AddOp.new(4, 6).eval(env)
    assert_equal expected, actual
  end

  def test_addop_with_env
    env = Environment.new([{x: IntVal.new(4), y: IntVal.new(6)}])
    expected = IntVal.new(10)
    actual = AddOp.new(:x, :y).eval(env)
    assert_equal expected, actual
  end

  def test_lambda
    env = Environment.new()
    expected = IntVal.new(5)
    actual = Lambda.new([:x, :y], 
                        AddOp.new(:x, :y)
                       ).apply(env, 3, 2)
    assert_equal expected, actual
  end
  def test_let
    env = Environment.new()
    expected = IntVal.new(5)
    actual = Let.new([[:x, 3], [:y, 2]], AddOp.new(:x, :y)).eval(env)
    assert_equal expected, actual
  end

  def test_closure
    env = Environment.new()
    expected = IntVal.new(9)
    actual = Let.new([[:x, 3]], 
                     Let.new([[:fun, 
                               Lambda.new(
                                 [:y], 
                                 AddOp.new(:x, :y))]],
                     AddOp.new(Func.new(:fun, 1), Func.new(:fun, 2))
                            )
                    ).eval(env)
    assert_equal expected, actual
  end
end
