require 'test_helper'

class ConsolationTest < ActiveSupport::TestCase
  include Consolation

  test "test console with default" do
    assert_nothing_raised do
      consolation("some string")
    end
  end

  test "test console with auto lines" do
    assert_nothing_raised do
      consolation("1. some string")
    end
  end
end
