require 'spec_helper'

describe '#spm_project_from_swift_modules' do
  it 'creates the required directories and symlinks the listed files' do
    mkdir_p_mock = Minitest::Mock.new
    mkdir_p_mock.expect :call, true, [ "/tmp/dir/Sources/MyApp" ]
    mkdir_p_mock.expect :call, true, [ "/tmp/dir/Sources/MyAppTests" ]

    ln_s_mock = Minitest::Mock.new
    ln_s_mock.expect :call, true, [ '/project/filea.swift', '/tmp/dir/Sources/MyApp' ]
    ln_s_mock.expect :call, true, [ '/project/fileaTests.swift', '/tmp/dir/Sources/MyAppTests' ]

    pwd_mock = Minitest::Mock.new
    pwd_mock.expect :call, '/project'
    pwd_mock.expect :call, '/project'

    swift_modules = [
      Swift::Gist::SwiftModule.new('MyApp', :src, [ 'filea.swift' ]),
      Swift::Gist::SwiftModule.new('MyAppTests', :test, [ 'fileaTests.swift' ]),
    ]

    Swift::Gist::spm_project_from_swift_modules(swift_modules, ln_s: ln_s_mock, mkdir_p: mkdir_p_mock, pwd: pwd_mock, tmp_dir: '/tmp/dir')

    assert_mock mkdir_p_mock
    assert_mock pwd_mock
    assert_mock ln_s_mock
  end
end
