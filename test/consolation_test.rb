require 'test_helper'

class ConsolationTest < ActiveSupport::TestCase
  include Consolation
  test "create short log chunk" do
    assert_difference 'LogChunk.count', 1 do
      LogChunk.create(
        content: "hey"
      )
    end
  end

  test "log_chunk should handle being huge" do
    assert_difference 'LogChunk.count', 3  do
      LogChunk.create!(
        content: File.read(File.join(ActiveSupport::TestCase.fixture_path, 'long_string.txt'))
      )
    end
  end
end
