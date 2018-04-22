require 'spec_helper'

describe '#run' do

  it 'orchestrates all the functions into a meaningful flow' do
    swift_modules = [ Swift::Gist::SwiftModule.new('MyApp', :src, []) ]

    # 1 - Parses command line arguments
    cli_mock = Minitest::Mock.new
    cli_mock.expect :call, swift_modules, [ %w[--module MyApp] ]

    # 2 - Grab the project path
    pwd_mock = Minitest::Mock.new
    pwd_mock.expect :call, '/project'

    # 3 - Creates tmp dir to create project in
    mktmpdir_mock = Minitest::Mock.new
    mktmpdir_mock.expect(:call, '/tmp/dir') { |&block|
      block.call('/tmp/dir')
      true
    }

    # 4 - Changes the working directory to the new tmp dir
    chdir_mock = Minitest::Mock.new
    chdir_mock.expect(:call, true) { |dir, &block|
      block.call
      assert_equal '/tmp/dir', dir
    }

    # 5 - It creates the project structure
    spm_project_creator_mock = Minitest::Mock.new
    spm_project_creator_mock.expect :call, nil, [ swift_modules, project_dir: '/project' ]

    # 6 - Writes out the Package.swift file
    open_mock = Minitest::Mock.new
    open_mock.expect(:call, nil) { |file_name, mode, &block|
      assert_equal 'Package.swift', file_name
      assert_equal 'w', mode

      contents_written = StringIO.new
      block.call(contents_written)
      assert_equal "Package Stuff\n", contents_written.string
    }

    # 6.1 - Generates the contents of the Package.swift file
    spm_package_creator_mock = Minitest::Mock.new
    spm_package_creator_mock.expect :call, "Package Stuff\n", [ swift_modules ]

    # 7 - Starts watchman
    system_mock = Minitest::Mock.new
    system_mock.expect :call, nil, [ 'SOME COMMAND' ]

    # 7.1 - It builds the watchman command
    watchman_command_mock = Minitest::Mock.new
    watchman_command_mock.expect :call, 'SOME COMMAND', [ '/tmp/dir', swift_modules ]

    Swift::Gist::run(
      %w[--module MyApp],
      cli: cli_mock,
      pwd: pwd_mock,
      mktmpdir: mktmpdir_mock,
      chdir: chdir_mock,
      spm_package_creator: spm_package_creator_mock,
      spm_project_creator: spm_project_creator_mock,
      system: system_mock,
      open: open_mock,
      watchman_command: watchman_command_mock
    )

    assert_mock cli_mock
    assert_mock pwd_mock
    assert_mock mktmpdir_mock
    assert_mock chdir_mock
    assert_mock spm_package_creator_mock
    assert_mock spm_project_creator_mock
    assert_mock open_mock
    assert_mock system_mock
    assert_mock watchman_command_mock
  end
end
