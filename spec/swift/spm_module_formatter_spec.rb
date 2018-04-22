require 'spec_helper'

describe '#format_swift_module' do
  it 'returns a `target` case when the type is :src' do
    assert_equal(
      '.target(name: "MyApp")',
      Swift::Gist::format_swift_module(Swift::Gist::SwiftModule.new('MyApp', :src, []))
    )
  end

  it 'returns a `testTarget` case when the type is :test' do
    assert_equal(
      '.testTarget(name: "MyApp")',
      Swift::Gist::format_swift_module(Swift::Gist::SwiftModule.new('MyApp', :test, []))
    )
  end

  it 'adds dependencies when they are supplied' do
    assert_equal(
      '.target(name: "MyApp", dependencies: ["OtherModule"])',
      Swift::Gist::format_swift_module(Swift::Gist::SwiftModule.new('MyApp', :src, [], ['OtherModule']))
    )
  end
end
