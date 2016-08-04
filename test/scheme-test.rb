require 'test/unit'
require_relative '../src/scheme'

class SchemeTest < Test::Unit::TestCase
  def test_num?
    assert_equal true, num?(0)
    assert_equal false, num?([:+, 1, 2])
  end

  def test_list?
    assert_equal true, list?([:+, 1, 2])
    assert_equal false, list?(0)
  end

  def test_car
    expected = :+
    actual = car([:+, 1, 2])
    assert_equal expected, actual
  end

  def test_cdr
    expected = [1, 2]
    actual = cdr([:+, 1, 2])
    assert_equal expected, actual
  end

  def test_lookup_primitive_fun_symbol
    expected = [:prim, lambda{|x, y| x + y}]
    actual = lookup_primitive_fun(:+)
    assert_equal expected.first, actual.first
  end

  def test_lookup_primitive_fun
    # [:prim, lambda{|x, y| x + y}]
    add_fun = lookup_primitive_fun(:+)
    sub_fun = lookup_primitive_fun(:-)
    mult_fun = lookup_primitive_fun(:*)

    assert_equal(3, add_fun[1].call(1, 2))
    assert_equal(-1, sub_fun[1].call(1, 2))
    assert_equal(2, mult_fun[1].call(1, 2))
  end

  def test_apply_primitive_fun
    # [:prim, lambda{|x, y| x + y}]
    list = [:+, 1, 2]
    add_fun = lookup_primitive_fun(car(list))
    args = eval_list(cdr(list))

    expected = 3
    actual = apply_primitive_fun(add_fun, args)
    assert_equal expected, actual
  end

  def test_eval_simple
    list = [:*, 2, 5]

    expected = 10
    actual = _eval(list)
    assert_equal expected, actual
  end

  def test_eval_list
    list = [:*, [:+, 1, 2], 5]
    
    expected = [3, 5]
    actual = eval_list(cdr(list))
    assert_equal expected, actual
  end

   def test_eval
    list = [:*, [:+, 1, 2], 5]
    
    expected = 15
    actual = _eval(list)
    assert_equal expected, actual
  end
end
