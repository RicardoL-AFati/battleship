require './test/test_helper'

class ExampleTest < Minitest::Test
  def setup
    @example = Example.new('example')
  end

  def test_it_exists
    assert_instance_of Example, @example
  end

end
