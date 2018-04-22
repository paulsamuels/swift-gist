module Swift
  module Gist
    def self.watchman_paths_from_swift_modules swift_modules
      swift_modules
      .map { |swift_module| swift_module.sources }
      .flatten
      .map { |path| %Q|'#{path}'| }
      .join(' ')
    end
  end
end
