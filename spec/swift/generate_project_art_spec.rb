require 'spec_helper'

describe '#generate_project_art' do
  it 'generates a tree' do
    swift_modules = [
      Swift::Gist::SwiftModule.new('MyApp', :src, [ 'filea.swift', 'fileb.swift' ]),
      Swift::Gist::SwiftModule.new('MyAppTests', :test, [ 'fileaTests.swift' ]),
    ]

    expected_description = <<DESCRIPTION
/tmp/dir
.
├── Package.swift
└── Sources
    ├── MyApp
    │   ├── filea.swift
    │   └── fileb.swift
    └── MyAppTests
        └── fileaTests.swift
DESCRIPTION

    assert_equal expected_description, Swift::Gist::generate_project_art(swift_modules, '/tmp/dir')
  end
end
