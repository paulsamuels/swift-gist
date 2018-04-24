require 'spec_helper'

describe '#run' do

  it 'orchestrates all the functions into a meaningful flow' do
    swift_modules = [ Swift::Gist::SwiftModule.new('MyApp', :src, []) ]

    stdout_mock = Minitest::Mock.new

    # 1 - Parses command line arguments
    cli_mock = Minitest::Mock.new
    cli_mock.expect :call, swift_modules, [ %w[--module MyApp] ]

    # 2 - It generates the SPM project
    project_generator_mock = Minitest::Mock.new
    project_generator_mock.expect :call, '/tmp/dir', [ swift_modules ]

    project_art_generator_mock = Minitest::Mock.new
    project_art_generator_mock.expect :call, 'SOME ART', [ swift_modules, '/tmp/dir' ]
    stdout_mock.expect :call, nil, [ 'SOME ART' ]

    # 3 - Start watching
    chdir_mock = Minitest::Mock.new
    chdir_mock.expect(:call, true) { |dir, &block|
      block.call
      assert_equal '/tmp/dir', dir
    }
    watcher_mock = Minitest::Mock.new
    watcher_mock.expect :call, nil do |swift_modules_arg, &block|
      block.call
      assert_equal swift_modules, swift_modules_arg
    end

    formatted_date_mock = Minitest::Mock.new
    formatted_date_mock.expect :call, '2018-04-24 21:53:47 UTC'

    stdout_mock.expect :call, nil, [ "\n\n-----> Running `$ swift test` @ '2018-04-24 21:53:47 UTC' - Build #1"]

    system_mock = Minitest::Mock.new
    system_mock.expect :call, true, [ 'swift test' ]

    # 4 - It tidies up after itself
    rm_rf_mock = Minitest::Mock.new
    rm_rf_mock.expect :call, nil, [ '/tmp/dir' ]

    assert_equal 0, Swift::Gist::run(
      %w[--module MyApp],
      chdir: chdir_mock,
      cli: cli_mock,
      formatted_date: formatted_date_mock,
      project_art_generator: project_art_generator_mock,
      project_generator: project_generator_mock,
      rm_rf: rm_rf_mock,
      stdout: stdout_mock,
      system: system_mock,
      watcher: watcher_mock
    )

    assert_mock chdir_mock
    assert_mock cli_mock
    assert_mock formatted_date_mock
    assert_mock project_art_generator_mock
    assert_mock project_generator_mock
    assert_mock rm_rf_mock
    assert_mock stdout_mock
    assert_mock system_mock
    assert_mock watcher_mock
  end
end
