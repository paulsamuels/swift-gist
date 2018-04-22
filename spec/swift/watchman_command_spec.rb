require 'spec_helper'

describe '#watchman_command' do
  it 'constructs the run watchman command' do
    watchman_paths = Minitest::Mock.new
    watchman_paths.expect :call, "'path.swift'", [ [ SwiftModule.new('MyApp', :src, []) ]]

    input = [ SwiftModule.new('MyApp', :src, []) ]

    assert_equal(
      "watchman-make -p 'path.swift' --run 'cd tmp_dir/ && swift test'",
      Swift::Gist::watchman_command('tmp_dir/', input, watchman_paths_from_swift_modules: watchman_paths)
    )

    assert_mock watchman_paths
  end
end
