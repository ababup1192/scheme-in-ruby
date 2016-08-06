require 'test/unit'
require_relative '../src/scheme'

class InterpreterTest < Test::Unit::TestCase
  def test_eval
    expected = 3
    exp = AddOp.new(IntVal.new(1), IntVal.new(2))
    actual = Interpreter.eval(exp)
    assert_equal expected, actual
  end
end

