# swift-gist

A tool to reduce feedback cycles when doing TDD with Swift.

TDD for iOS can be extremely painful as the feedback cycle (time from save to test results) is just too slow. The slow downs come from things like building lots of source code, code signing and simulator startup.

This tool can help in certain cases to get feedback cycles to acceptable levels. The basic idea is that you manually (sounds painful but it's not too bad) pick the files you want to build and test, the fewer the better. Run `swift-gist` and it will create an SPM project in a tmp directory that links to just the files you specify and then starts to watch these files and run tests whenever a file is saved. The heavy lifting is picked up by SPM so this means you cannot specify files that `import UIKit`. It's also advisable to keep dependencies to a minimum (which I guess is just normally good advice).

---

## Usage

Invoke the `swift-gist` command and tell it about how you want your project set up (you can always save this command in a nice shell script for reuse later).

The first argument should be either `--module` or `--test-module` followed by a name for the module. It's best to mirror your projects current module naming e.g. if I have a project called `MyApp` then I would use `--module MyApp` as the tests will be looking to `import MyApp`.

After you have defined a module you should add some source code. You can invoke `--source` with quoted globs (quoted so that your shell does not automatically expand them) as many times as you like. The globs will be expanded with the resulting paths being combined and added to the last defined module.

Finally you can have as many `--depends-on` arguments as you like. Multiple invocations will be added to the last defined module. On a simple project you'll need to use this to tell the test module about the module it is testing.

That was a lot of text - how about an example.

Given this project:

```
MyApp
├── Source
│   └── FeatureA
│       ├── ...
│       ├── hundreds of other files
│       ├── ...
│       └── ImportantClass.swift
└── Tests
    └── FeatureA
        ├── ...
        ├── hundreds of other files
        ├── ...
        └── ImportantClassTests.swift
```

If I am looking to do a tight TDD loop on the `ImportantClass` file and it only depends on `Foundation` I can use the following invocation.

```
swift-gist --module MyApp \
           --source 'Source/Feature/ImportantClass.swift' \
           --test-module MyAppTests \
           --source 'Tests/Feature/ImportantClassTests.swift' \
           --depends-on MyApp
```

This will cause my shell to start watching for file saves. Every time a file is saved it will run the unit tests.

---

## Installation

`gem install swift-gist`

---

## Why make this tool?

TDD really requires sub second cycle times for optimal flow. Even small projects can take multiple minutes to build and test - large projects are much worse. This leads to the tendency to take bigger steps in your development flow to batch work up instead of paying the cost of a build/test cycle. This tool aims to allow you (with a little manual effort) to finely craft what you want to build and test to suit what you are working on here and now. That could be specifying a specific file or building more elaborate watches.

## Why not do the whole modularization thing that is so popular right now?

Personally I think the move towards modularization is great for development speed and engineering good practices like defining boundaries and isolating parts of your app. The reason for `swift-gist` is that modularization is cool but for most people it's either going to be a very slow transformation or not viable but they are still feeling pain now. This is an attempt to help sooth the pain a little without requiring a massive reshaping of your existing code base.

## Why make this in Ruby?

I've kept this to not using any fancy ruby dependencies, so if you are using Sierra or High Sierra you already have everything you need to use this tool. Although it's possible to write this in Swift - I think it's easier to write `gem install swift-gist` than it is to figure out how to package this for Swift.

---

## I found a bug - what do I do?

Sweet, thanks for trying this tool out - could you spare some time to raise an issue? Likelihood is it's because the tool is a rough proof of concept and needs hardening to common issues and better documentation.

If you can write ruby - submit a PR and I'll be happy to look at it. If you are going to write a massive PR it might be worth discussing the proposed changes first to avoid disappointment if the changes don't get accepted.
