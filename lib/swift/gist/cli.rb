require 'optparse'

module Swift
  module Gist

    # The CLI creates a new module for every `--module` or `--test-module`
    # argument. The `--source` and `--depends-on` arguments are all applied
    # to the last defined swift module.
    def self.parse_command_line_arguments arguments
      swift_modules = []

      OptionParser.new do |parser|
        parser.on('--module MODULE') do |module_name|
          swift_modules << SwiftModule.new(module_name, :src, [])
        end

        parser.on('--source SOURCE') do |source|
          swift_modules.last.sources |= Dir[source]
        end

        parser.on('--test-module MODULE') do |module_name|
          swift_modules << SwiftModule.new(module_name, :test, [])
        end

        parser.on('--depends-on MODULE') do |module_name|
          swift_modules.last.depends_on << module_name
        end
      end.parse arguments

      swift_modules
    end

  end
end
