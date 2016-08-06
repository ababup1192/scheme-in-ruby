require 'test/unit'
require_relative '../src/scheme'

class InterpreterTest < Test::Unit::TestCase
  def test_eval
    exp = MulOp.new(
      AddOp.new(
        IntVal.new(1), 
        SubOp.new(
          IntVal.new(3),
          IntVal.new(2)
        )
      ),
      IntVal.new(5)
    )

    expected = 10
    actual = Interpreter.eval(exp)
    assert_equal expected, actual
  end
end

