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
      system: method(:system),
      stdout: $stdout.method(:puts),
      watcher: method(:watch_sources)
    )

      swift_modules = cli.call arguments
      tmp_dir = project_generator.call(swift_modules)
      stdout.call project_art_generator.call(swift_modules, tmp_dir)

      chdir.call(tmp_dir) do
        system.call('swift test')
      end

      counter = 1
      watcher.call(swift_modules) do
        stdout.call "\n\n-----> Running `$ swift test` @ '#{formatted_date.call}' - Build ##{counter}"
        chdir.call(tmp_dir) do
          system.call('swift test')
        end

        counter += 1
      end

      0

    ensure
      rm_rf.call tmp_dir
    end

  end
end
