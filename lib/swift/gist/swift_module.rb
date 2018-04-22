module Swift
  module Gist
    class SwiftModule
      attr_accessor :name, :type, :sources, :depends_on

      def initialize name, type, sources, depends_on=[]
        @name, @type, @sources, @depends_on = name, type, sources, depends_on
      end

      def == other
        name == other.name && sources == other.sources && depends_on == other.depends_on && type == other.type
      end
    end
  end
end
