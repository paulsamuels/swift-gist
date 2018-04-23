module Swift
  module Gist
    def self.has_watchman_installed? system: method(:system)
      system.call('command -v watchman-make > /dev/null')
    end
  end
end
