module Swift
  module Gist

    def self.spm_project_from_swift_modules(
      swift_modules,
      project_dir:,
      mkdir_p: FileUtils.method(:mkdir_p),
      ln_s: FileUtils.method(:ln_s)
    )

      swift_modules.each do |swift_module|
        mkdir_p.call "Sources/#{swift_module.name}"
        swift_module.sources.each do |source|
          ln_s.call "#{project_dir}/#{source}", "Sources/#{swift_module.name}"
        end
      end
    end

  end
end
