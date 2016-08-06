require 'test/unit'
require_relative '../src/ast'

class IntValTest < Test::Unit::TestCase
  def test_eval
    expected = 1
    actual = IntVal.new(1).eval
    assert_equal expected, actual
  end
end

class AddOpValTest < Test::Unit::TestCase
  def test_eval
    expected = 4  
    actual = AddOp.new(IntVal.new(1), IntVal.new(3)).eval
    assert_equal expected, actual
  end

  def test_eval_nest
    expected = 10  
    actual = AddOp.new(
      AddOp.new(
        IntVal.new(1), IntVal.new(3)
      ),
      IntVal.new(6)
    ).eval
    assert_equal expected, actual
  end
end

class SubOpValTest < Test::Unit::TestCase
  def test_eval
    expected = -2  
    actual = SubOp.new(IntVal.new(1), IntVal.new(3)).eval
    assert_equal expected, actual
  end

  def test_eval_nest
    expected = -8
    actual = SubOp.new(
      SubOp.new(
        IntVal.new(1), IntVal.new(3)
      ),
      IntVal.new(6)
    ).eval
    assert_equal expected, actual
  end
end

class MulOpValTest < Test::Unit::TestCase
  def test_eval
    expected = 3
    actual = MulOp.new(IntVal.new(1), IntVal.new(3)).eval
    assert_equal expected, actual
  end

  def test_eval_nest
    expected = 18
    actual = MulOp.new(
      MulOp.new(
        IntVal.new(1), IntVal.new(3)
      ),
      IntVal.new(6)
    ).eval
    assert_equal expected, actual
  end
end

class AstOpValTest < Test::Unit::TestCase
  def test_eval
    expected = 10
    actual = MulOp.new(
      AddOp.new(
        IntVal.new(1), 
        SubOp.new(
          IntVal.new(3),
          IntVal.new(2)
        )
      ),
      IntVal.new(5)
    ).eval
    assert_equal expected, actual
  end
end


