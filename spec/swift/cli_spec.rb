require 'spec_helper'

describe '#parse_command_line_arguments' do
  it 'prints help if no arguments are provided' do
    expected = <<EXPECTED
Usage: swift-gist [--module[=<name>]] [--test-module[=<name>]]
                  [--source[=<glob>]] [--depends-on[=<module name>]]
EXPECTED

    exception = assert_raises do
      Swift::Gist::parse_command_line_arguments([])
    end

    assert_equal expected, exception.reason
  end

  it 'raises an error if --source is used before --test or --test-module' do
    expected = "Error: The `--source` argument requires that a `--module` or `--test-module` has already been defined."

    exception = assert_raises do
      Swift::Gist::parse_command_line_arguments(%w[--source ''])
    end

    assert_equal expected, exception.reason
  end

  it 'raises an error if --depends-on is used before --test or --test-module' do
    expected = "Error: The `--depends-on` argument requires that a `--module` or `--test-module` has already been defined."

    exception = assert_raises do
      Swift::Gist::parse_command_line_arguments(%w[--depends-on ''])
    end

    assert_equal expected, exception.reason
  end

  it 'raises an error if there are no valid sources' do
    expected = "Error: The module 'MyApp' does not have any valid sources."

    exception = assert_raises do
      Swift::Gist::parse_command_line_arguments(%w[--module MyApp --source ''])
    end

    assert_equal expected, exception.reason
  end

  it 'creates a swift module from a module name and some source globs' do
    result = Swift::Gist::parse_command_line_arguments(
      %w[--module MyApp --source Gemfile]
    ).first

    assert_equal 'MyApp', result.name
    assert_equal :src, result.type
    assert_equal [ 'Gemfile' ], result.sources
  end

  it 'creates a swift test module from a module name and some source globs' do
    result = Swift::Gist::parse_command_line_arguments(
      %w[--test-module MyAppTests --source .gitignore]
    ).first

    assert_equal 'MyAppTests', result.name
    assert_equal :test, result.type
    assert_equal [ '.gitignore' ], result.sources
  end

  it 'add dependencies to the last module' do
    result = Swift::Gist::parse_command_line_arguments(
      %w[--module MyApp --source Gemfile --depends-on OtherModule]
    ).first

    assert_equal [ 'OtherModule' ], result.depends_on
  end

  it 'adds multiple --source arguments to the last module' do
    result = Swift::Gist::parse_command_line_arguments(
      %w[--module MyApp --source Gemfile --source Rakefile]
    ).first

    assert_equal [ 'Gemfile', 'Rakefile' ], result.sources
  end

  it 'creates a new module for every --module/--test-module invocation' do
    result = Swift::Gist::parse_command_line_arguments(
      %w[--module A --source Gemfile --test-module ATests --source Rakefile --depends-on A]
    )

    assert_equal 'A', result[0].name
    assert_equal [ 'Gemfile' ], result[0].sources
    assert_equal 'ATests', result[1].name
    assert_equal [ 'Rakefile' ], result[1].sources
    assert_equal [ 'A' ], result[1].depends_on
  end
end
