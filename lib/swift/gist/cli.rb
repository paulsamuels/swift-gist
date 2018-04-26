require 'optparse'

module Swift
  module Gist
    class CLIError < StandardError
      attr_accessor :reason

      def initialize reason
        self.reason = reason
      end
    end

    # The CLI creates a new module for every `--module` or `--test-module`
    # argument. The `--source` and `--depends-on` arguments are all applied
    # to the last defined swift module.
    def self.parse_command_line_arguments arguments
      unless arguments.count > 0
        error = CLIError.new(<<REASON
Usage: swift-gist [--module[=<name>]] [--test-module[=<name>]]
                  [--source[=<glob>]] [--depends-on[=<module name>]]
REASON
)
        raise error
      end

      swift_modules = []

      OptionParser.new do |parser|
        parser.on('--module MODULE') do |module_name|
          swift_modules << SwiftModule.new(module_name, :src, [])
        end

        parser.on('--source SOURCE') do |source|
          if swift_modules.last.nil?
            raise CLIError.new("Error: The `--source` argument requires that a `--module` or `--test-module` has already been defined.")
          end

          swift_modules.last.sources |= Dir[source]
        end

        parser.on('--test-module MODULE') do |module_name|
          swift_modules << SwiftModule.new(module_name, :test, [])
        end

        parser.on('--depends-on MODULE') do |module_name|
          if swift_modules.last.nil?
            raise CLIError.new("Error: The `--depends-on` argument requires that a `--module` or `--test-module` has already been defined.")
          end
          swift_modules.last.depends_on << module_name
        end
      end.parse arguments

      swift_modules.each do |swift_module|
        if swift_module.sources.count == 0
          raise CLIError.new("Error: The module '#{swift_module.name}' does not have any valid sources.")
        end
      end

      swift_modules
    end

  end
end
