module SlackNeuralyzer
  module Errors
    class RequiredArgumentsError < StandardError
      def initialize(message)
        super("Must required one of these arguments: #{message}")
      end
    end
  end
end
