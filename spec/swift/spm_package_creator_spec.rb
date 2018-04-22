require 'spec_helper'

describe '#spm_package_definition_from_swift_modules' do
  it 'generates a definition from swift modules' do
    expected = <<-EXPECTED
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "TestRunner",
    targets: [ TARGET_1, TARGET_2 ]
)
EXPECTED

    source_module = Swift::Gist::SwiftModule.new('MyApp', :src, [ 'file.swift' ])
    test_module   = Swift::Gist::SwiftModule.new('MyAppTests', :test, [ 'fileTest.swift' ])

    swift_modules = [ source_module, test_module ]

    format_swift_module = Minitest::Mock.new
    format_swift_module.expect :call, "TARGET_1", [ source_module ]
    format_swift_module.expect :call, "TARGET_2", [ test_module ]

    assert_equal expected, Swift::Gist::spm_package_definition_from_swift_modules(swift_modules, format_swift_module: format_swift_module)
    assert_mock format_swift_module
  end
end
