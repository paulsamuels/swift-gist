module Swift
  module Gist
    class SwiftModule
      attr_accessor :name, :type, :sources, :depends_on

      def initialize name, type, sources, depends_on=[]
        @name, @type, @sources, @depends_on = name, type, sources, depends_on
      end
    end
  end
end
