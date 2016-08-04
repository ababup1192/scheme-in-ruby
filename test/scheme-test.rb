require 'test/unit'
require_relative '../src/scheme'

class SchemeTest < Test::Unit::TestCase
  def test_num?
    assert_equal true, num?(0)
    assert_equal false, num?([1, 2, 3])
  end
end
