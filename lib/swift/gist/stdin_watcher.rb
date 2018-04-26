module Swift
  module Gist

    def self.watch_stdin stdin: STDIN
      while stdin.gets
        yield
      end
    end

  end
end
