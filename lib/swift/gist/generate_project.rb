module Swift
  module Gist

    def self.generate_project(
      swift_modules,
      mktmpdir: Dir.method(:mktmpdir),
      open: File.method(:open),
      spm_package_creator: method(:spm_package_definition_from_swift_modules),
      spm_project_creator: method(:spm_project_from_swift_modules)
    )

      mktmpdir.call.tap do |tmp_dir|
        spm_project_creator.call swift_modules, tmp_dir: tmp_dir

        open.call("#{tmp_dir}/Package.swift", 'w') do |file|
          file.puts spm_package_creator.call(swift_modules)
        end
      end

    end

  end
end
