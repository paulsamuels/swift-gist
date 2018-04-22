module Swift
  module Gist

    # This function generates a valid swift case for each SwiftModule.
    #
    # The resulting output will be something like:
    #
    # .target(name: "SomeModule")
    # .target(name: "SomeModule", dependencies: ["SomeOtherModule"])
    # .testTarget(name: "SomeModuleTests", dependencies: ["SomeOtherModule"])
    def self.format_swift_module swift_module
        target_type = swift_module.type == :src ? 'target' : 'testTarget'
        formatted_name = %Q|name: "#{swift_module.name}"|
        formatted_dependencies = "dependencies: [%s]" % swift_module.depends_on.map { |dependency| %Q|"#{dependency}"| }.join(', ')

        %Q|.%{target_type}(%{formatted_name}%{formatted_dependencies})| % {
          target_type: target_type,
          formatted_name: formatted_name,
          formatted_dependencies: swift_module.depends_on.count > 0 ? ", #{formatted_dependencies}" : ""
        }
    end
  end
end
