require 'erb'

module Swift
  module Gist
    def self.spm_package_definition_from_swift_modules swift_modules, format_swift_module: method(:format_swift_module)
      formatted_modules = swift_modules.map { |swift_module| format_swift_module.call swift_module }
      ERB.new(ERB_TEMPLATE).result(binding)
    end

    private

    ERB_TEMPLATE = <<-ERB_TEMPLATE
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "TestRunner",
    targets: [ <%= formatted_modules.join(", ") %> ]
)
ERB_TEMPLATE
  end
end
