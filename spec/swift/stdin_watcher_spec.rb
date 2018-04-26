require 'spec_helper'

describe '#watch_stdin' do
  it 'executes the build command for any new line on stdin' do
    did_yield = false
    stdin_mock = Minitest::Mock.new
    stdin_mock.expect :gets, "\n"
    stdin_mock.expect :gets, nil

    Swift::Gist::watch_stdin stdin: stdin_mock do
      did_yield = true
    end

    assert did_yield
    assert_mock stdin_mock
  end
end
