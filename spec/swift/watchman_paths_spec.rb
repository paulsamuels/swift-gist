require 'spec_helper'

describe '#watchman_paths_from_swift_modules' do
  it 'reduces all module sources into a space delimited list' do
    swift_modules = [
      Swift::Gist::SwiftModule.new('', :src, [ 'filea.swift' ]),
      Swift::Gist::SwiftModule.new('', :src, [ 'fileb.swift' ]),
    ]

    assert_equal(
      "'filea.swift' 'fileb.swift'",
      Swift::Gist::watchman_paths_from_swift_modules(swift_modules)
    )
  end
end
