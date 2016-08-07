require 'test/unit'
require_relative '../src/scheme'


class EvalFuncTest < Test::Unit::TestCase
  def test_variable
    expected = IntVal.new(5)
    actual = Interpreter.new(IntVal.new(5)).eval
    assert_equal expected, actual
  end
  def test_addop
    expected = IntVal.new(10)
    actual = Interpreter.new(AddOp.new(4, 6)).eval
    assert_equal expected, actual
  end

  def test_lambda
    exp = Lambda.new([:x, :y], AddOp.new(:x, :y)).apply(3, 2)
    expected = IntVal.new(5)
    actual = Interpreter.new(exp).eval
    assert_equal expected, actual
  end

=begin
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
=end
end
