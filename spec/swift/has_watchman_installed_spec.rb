require 'spec_helper'

describe '#has_watchman_installed?' do
  it 'returns true when installed' do
    system_mock = Minitest::Mock.new
    system_mock.expect :call, true, [ 'command -v watchman-make > /dev/null' ]

    assert Swift::Gist::has_watchman_installed?(system: system_mock)

    assert_mock system_mock
  end

  it 'returns false when not installed' do
    system_mock = Minitest::Mock.new
    system_mock.expect :call, false, [ 'command -v watchman-make > /dev/null' ]

    refute Swift::Gist::has_watchman_installed?(system: system_mock)

    assert_mock system_mock
  end
end
