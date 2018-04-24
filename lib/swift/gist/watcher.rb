require 'listen'

module Swift
  module Gist
    def self.watch_sources swift_modules, listener: Listen, sleep: method(:sleep)
      sources = Set.new(swift_modules.map { |swift_module| swift_module.sources }.flatten)
      dirs    = Set.new(sources.map { |path| Dir.exist?(path) ? path : File.dirname(path) })

      listener.to(*dirs, only: /.*swift/, relative: true) do |modified, created, deleted|
        next unless sources.intersect?(Set.new(modified + created + deleted))
        yield
      end.start

      sleep.call
    end
  end
end
