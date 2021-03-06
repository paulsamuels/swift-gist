require 'fileutils'
require 'time'
require 'tmpdir'

module Swift
  module Gist

    # This is the ugly command that binds everything together.
    #
    # 1 - Parses command line arguments
    # 2 - Creates a SPM project linking just the files specified with `--source` arguments
    def self.run(
      arguments,
      chdir: Dir.method(:chdir),
      cli: method(:parse_command_line_arguments),
      formatted_date: -> { Time.iso8601(Time.now.iso8601) },
      project_art_generator: method(:generate_project_art),
      project_generator: method(:generate_project),
      rm_rf: FileUtils.method(:rm_rf),
      stdin_watcher: method(:watch_stdin),
      stdout: $stdout.method(:puts),
      system: method(:system),
      watcher: method(:watch_sources)
    )

      begin
        swift_modules = cli.call arguments
      rescue CLIError => error
        puts error.reason
        exit
      end

      begin
        tmp_dir = project_generator.call(swift_modules)
        stdout.call project_art_generator.call(swift_modules, tmp_dir)

        chdir.call(tmp_dir) do
          system.call('swift test')
        end

        counter = 1

        build_command = -> {
          stdout.call "\n\n-----> Running `$ swift test` @ '#{formatted_date.call}' - Build ##{counter}"
          chdir.call(tmp_dir) do
            system.call('swift test')
          end

          counter += 1
        }

        watcher.call(swift_modules, &build_command)
        stdin_watcher.call(&build_command)

      ensure
        rm_rf.call tmp_dir
      end

      0
    end

  end
end
