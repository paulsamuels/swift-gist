require "spec_helper"

include Swift::Gist

describe VERSION do
  it 'has a version number' do
    refute_nil ::Swift::Gist::VERSION
  end
end
