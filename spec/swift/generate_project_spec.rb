require 'spec_helper'

describe '#generate_project' do
  it 'coordinates the creation of a project' do
    swift_modules = [
      Swift::Gist::SwiftModule.new('MyApp', :src, [ 'filea.swift' ]),
      Swift::Gist::SwiftModule.new('MyAppTests', :test, [ 'fileaTests.swift' ]),
    ]

    # 1 - Creates tmp dir to create project in
    mktmpdir_mock = Minitest::Mock.new
    mktmpdir_mock.expect(:call, '/tmp/dir')
    
    # 2 - It creates the project structure
    spm_project_creator_mock = Minitest::Mock.new
    spm_project_creator_mock.expect :call, nil, [ swift_modules, tmp_dir: '/tmp/dir' ]

    # 3 - Writes out the Package.swift file
    open_mock = Minitest::Mock.new
    open_mock.expect(:call, nil) { |file_name, mode, &block|
      assert_equal '/tmp/dir/Package.swift', file_name
      assert_equal 'w', mode

      contents_written = StringIO.new
      block.call(contents_written)
      assert_equal "Package Stuff\n", contents_written.string
    }

    # 4 - Generates the contents of the Package.swift file
    spm_package_creator_mock = Minitest::Mock.new
    spm_package_creator_mock.expect :call, "Package Stuff\n", [ swift_modules ]

    result = Swift::Gist::generate_project(
      swift_modules,
      mktmpdir: mktmpdir_mock,
      open: open_mock,
      spm_package_creator: spm_package_creator_mock,
      spm_project_creator: spm_project_creator_mock
    )

    assert_equal '/tmp/dir', result

    assert_mock mktmpdir_mock
    assert_mock open_mock
    assert_mock spm_package_creator_mock
    assert_mock spm_project_creator_mock
  end
end
