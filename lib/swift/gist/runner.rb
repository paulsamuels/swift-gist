require 'fileutils'
require 'tmpdir'

module Swift
  module Gist

    # This is the ugly command that binds everything together.
    #
    # 1 - Parses command line arguments
    # 2 - Creates a SPM project linking just the files specified with `--source` arguments
    # 3 - Starts watchman
    def self.run(
      arguments,
      chdir: Dir.method(:chdir),
      cli: method(:parse_command_line_arguments),
      has_watchman_installed: method(:has_watchman_installed?),
      mktmpdir: Dir.method(:mktmpdir),
      open: File.method(:open),
      pwd: Dir.method(:pwd),
      spm_package_creator: method(:spm_package_definition_from_swift_modules),
      spm_project_creator: method(:spm_project_from_swift_modules),
      stdout: $stdout,
      system: method(:system),
      watchman_command: method(:watchman_command)
    )

      unless has_watchman_installed.call
        stdout.puts "watchman is a required dependency. `brew update && brew install watchman`."
        stdout.puts "https://facebook.github.io/watchman/"
        return 1
      end

      swift_modules = cli.call arguments
      project_dir   = pwd.call

      mktmpdir.call do |tmp_dir|
        chdir.call(tmp_dir) do
          spm_project_creator.call swift_modules, project_dir: project_dir

          open.call('Package.swift', 'w') do |file|
            file.puts spm_package_creator.call(swift_modules)
          end
        end

        system.call(watchman_command.call(tmp_dir, swift_modules))
      end

      0
    end

  end
end
