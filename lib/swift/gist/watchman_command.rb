module Swift
  module Gist
    def self.watchman_command dir, swift_modules, watchman_paths_from_swift_modules: method(:watchman_paths_from_swift_modules)
      sources = watchman_paths_from_swift_modules.call(swift_modules)
      "watchman-make -p #{sources} --run 'cd #{dir} && swift test'"
    end
  end
end
