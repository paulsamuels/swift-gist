require 'spec_helper'

describe '#watch_sources' do
  before do
    @listen_mock = Minitest::Mock.new
    @listen_mock.expect :to, @listen_mock do |*args, options, &block|
      @captured_block = block
      assert_equal [ 'source', 'test' ], args
      assert_equal({ only: /.*swift/, relative: true }, options)
    end
    @listen_mock.expect :start, nil

    @yield_count = 0
  end

  after do
    assert_mock @listen_mock
  end

  it 'sets up a watcher on all passed sources' do
    swift_modules = [
      Swift::Gist::SwiftModule.new('MyApp', :src, [ 'source/filea.swift' ]),
      Swift::Gist::SwiftModule.new('MyAppTests', :test, [ 'test/fileaTests.swift' ]),
    ]

    Swift::Gist::watch_sources(swift_modules, listener: @listen_mock)
  end

  it 'does not trigger for unknown paths' do
    swift_modules = [
      Swift::Gist::SwiftModule.new('MyApp', :src, [ 'source/filea.swift' ]),
      Swift::Gist::SwiftModule.new('MyAppTests', :test, [ 'test/fileaTests.swift' ]),
    ]

    Swift::Gist::watch_sources(swift_modules, listener: @listen_mock) do
      @yield_count += 1
    end

    @captured_block.call([ 'some/path.swift' ], [], [])

    assert_equal 0, @yield_count
  end

  it 'does trigger for known paths' do
    swift_modules = [
      Swift::Gist::SwiftModule.new('MyApp', :src, [ 'source/filea.swift' ]),
      Swift::Gist::SwiftModule.new('MyAppTests', :test, [ 'test/fileaTests.swift' ]),
    ]

    Swift::Gist::watch_sources(swift_modules, listener: @listen_mock) do
      @yield_count += 1
    end

    @captured_block.call([ 'source/filea.swift' ], [], [])
    @captured_block.call([ 'test/fileaTests.swift' ], [], [])

    assert_equal 2, @yield_count
  end

end
