module Swift
  module Gist
    def self.generate_project_art swift_modules, tmp_dir
      description = StringIO.new
      description.puts tmp_dir
      description.puts '.'
      description.puts "├── Package.swift"
      description.puts "└── Sources"
      swift_modules.sort_by { |swift_module| swift_module.name }.each_with_index do |swift_module, index|
        description.print index == swift_modules.length - 1 ? "    └── " : "    ├── "
        description.puts swift_module.name

        swift_module.sources.sort.each_with_index do |source, source_index|
          description.print index == swift_modules.length - 1               ? "     " : "    │"
          description.print source_index == swift_module.sources.length - 1 ? "   └── " : "   ├── "
          description.puts source
        end
      end
      description.string
    end
  end
end
