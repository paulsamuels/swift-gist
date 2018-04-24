require 'simplecov'
SimpleCov.start do
  add_filter %r{^/spec/}
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "swift/gist"

require "minitest/autorun"
