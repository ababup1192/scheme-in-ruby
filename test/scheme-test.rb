require 'test/unit'
require_relative '../src/scheme'


class SchemeTest < Test::Unit::TestCase
  class << self
    def startup
      @@global_env = $global_env
    end
  end

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

  def test_lookup_var
    actual = lookup_var(:+, @@global_env)
    assert_not_nil(actual)
  end

  def test_extetend_env
    expected = [{x: 1, y: 2}, {x: 3, y: 4}]
    actual = extend_env([:x, :y], [1, 2], [{x: 3, y: 4}])
    assert_equal expected, actual
  end

  def test_make_closure
    symbol, parameters, body, env = make_closure(
      [:lambda, [:x, :y], [:+, :x, :y]],
      [{x: 1, y: 2}]
    )

    assert_equal :closure, symbol
    assert_equal [:x, :y], parameters
    assert_equal [:+, :x, :y], body
    assert_equal([{x: 1, y: 2}], env)
  end

  def test_lambda_apply
    expected = 3
    actual = lambda_apply(make_closure(
      [:lambda, [:x, :y], [:+, :x, :y]],
      @@global_env),
      [1, 2])
    assert_equal expected, actual
  end

  def test_eval_let
    expected = 5
    actual = eval_let([:let, [[:x, 3], [:y, 2]], 
                       [:+, :x, :y]], @@global_env)
    assert_equal expected, actual
  end

  def test_closure_eval
    exp = [:let, [[:x, 3]],
           [:let, [[:fun, [:lambda, [:y], [:+, :x, :y]]]],
            [:+, [:fun, 1], [:fun, 2]]]]

    expected = 9
    actual = _eval(exp, @@global_env)
    assert_equal expected, actual
  end

  def test_eval_if
    exp = [:if, [:<, 1, 3], 1, 0]

    expected = 1
    actual = _eval(exp, @@global_env)
    assert_equal expected, actual
  end

  def test_letrec
    exp = [:letrec,
     [[:fact,
       [:lambda, [:n], [:if, 
                        [:<, :n, 1],
                        1, 
                        [:*, :n, [:fact, [:-, :n, 1]]]]]]],
     [:fact, 3]]
    
    expected = 6
    actual = _eval(exp, @@global_env)
    assert_equal expected, actual
  end

  def test_define
    exp1 = [:define, [:length, :list],
            [:if, [:null?, :list],
             0,
             [:+, [:length, [:cdr, :list]], 1]]]
    exp2 = [:length, [:list, 1, 2]]
    expected = 2
    _eval(exp1, @@global_env)
    actual = _eval(exp2, @@global_env)
    assert_equal expected, actual
  end

  def test_cond
    exp = [:cond,
           [[:>, 1, 1], 1],
           [[:>, 2, 1], 2],
           [[:>, 3, 1], 3],
           [:else, -1]]
    expected = 2
    actual = _eval(exp, @@global_env)
    assert_equal expected, actual
  end

  def test_parse
    exp = '(length (list 1 2 3))'
    expected = [:length, [:list, 1, 2, 3]]
    actual = parse(exp)
    assert_equal expected, actual
  end
end

